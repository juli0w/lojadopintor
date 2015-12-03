# encoding: UTF-8
require 'correios-frete'
class Order < ActiveRecord::Base
  CEP_ORIGEM = "89210681"
  REGION_SHIPPING_PRICE = 5.00
  REGION_CEP = 89200001..89239999 # Joinville

  belongs_to :user
  belongs_to :order_status
  belongs_to :coupon
  has_many :order_items

  scope :opened   , -> { where("order_status_id = ?", OrderStatus.opened).order("ID desc") }
  scope :confirmed, -> { where("order_status_id = ?", OrderStatus.confirmed).order("ID desc") }
  scope :paid     , -> { where("order_status_id = ?", OrderStatus.paid).order("ID desc") }
  scope :sent     , -> { where("order_status_id = ?", OrderStatus.sent).order("ID desc") }
  scope :canceled , -> { where("order_status_id = ?", OrderStatus.canceled).order("ID desc") }

  def self.filter state
    return self.all if state == "all" or state.nil?
    if %w(confirmed opened paid sent canceled).include? state
      return self.send(state)
    end

    return false
  end

  def initialize(attributes={})
    super attributes
    open!
  end

  def load_from_profile user
    self.customer_name = user.name
    self.customer_phone = user.phone
    self.customer_cellphone = user.cellphone
    self.shipping_address = user.address
    self.shipping_uf = user.uf
    self.shipping_city = user.city
    self.shipping_cep = user.cep if self.shipping_cep.nil?

    save
  end

  def add_item params
    order_item = order_items.select { |oi| oi.product_id == params[:product_id].to_i }.first
    qty = (params[:quantity].to_i > 0) ? params[:quantity].to_i : 1

    unless order_item.blank?
      order_item.quantity += qty
    else
      order_item = order_items.new(product_id: params[:product_id], quantity: qty)
    end

    order_item.save
    return order_item
  end

  def apply_coupon code
    return false unless Coupon.active?(code)
    self.coupon = Coupon.by_code(code)
    save
  end

  def calculate_subtotal
    @subtotal ||= order_items.collect { |oi| oi.valid? ? (oi.quantity * oi.unit_price) : 0 }.sum
  end

  def calculate_total
    @total ||= calculate_subtotal + calculate_shipping_price - calculate_discount
  end

  def calculate_discount
    return 0 if self.coupon.nil?

    d = self.coupon.value

    if self.coupon.discount_type = 0
      return calculate_subtotal * (d/100)
    else
      return d
    end
  end

  def shipping_error?
    extract_shipping_prices[:pac].valor <= 0 or extract_shipping_prices[:sedex].valor <= 0
  end

  def shipping_methods
    list = { 1 => :pac, 2 => :sedex }
    list[3] = :customizado if region_shipping?

    return list
  end

  def shipping_method_humanize
    shipping_methods[self.shipping_method]
  end

  def calculate_shipping_price
    services = extract_shipping_prices
    if services
      extract_shipping_prices[shipping_method_humanize].try(:valor)
    else
      0
    end
  end

  def extract_shipping_prices
    return false if self.shipping_cep.nil?

    pack = build_shipping_pack

    frete = Correios::Frete::Calculador.new({ :cep_origem => CEP_ORIGEM,
                                              :cep_destino => self.shipping_cep,
                                              :encomenda => pack })

    services = frete.calcular :pac, :sedex
    services[:customizado] = custom_shipping_service if region_shipping?

    return services
  end

  def custom_shipping_service
    OpenStruct.new(nome: "Customizado", valor: REGION_SHIPPING_PRICE, prazo_entrega: 2, observacao: "Apenas para a região de Joinville!")
  end

  def region_shipping?
    REGION_CEP.include?(self.shipping_cep.to_i)
  end

  def build_shipping_pack
    pack = Correios::Frete::Pacote.new

    order_items.collect do |oi|
      product = oi.product
      pack_item = Correios::Frete::PacoteItem.new({
        :peso => product.weight,
        :comprimento => product.width,
        :largura => product.depth,
        :altura => product.height })

      oi.quantity.times.each { pack.adicionar_item(pack_item) }
    end

    return pack
  end

  def waiting_payment?
    self.order_status == OrderStatus.confirmed
  end

  def setup! current_user_id
    self.user_id = current_user_id
    self.confirm!
    self.shipping_price = calculate_shipping_price
    self.subtotal = calculate_subtotal
    self.total = calculate_total

    save
  end

  def open!
    self.order_status = OrderStatus.opened
    save
  end

  def confirm!
    self.order_status = OrderStatus.confirmed
    save
  end

  def pay!
    self.order_status = OrderStatus.paid
    save
  end

  def cancel!
    self.order_status = OrderStatus.canceled
    save
  end

  def send!
    self.order_status = OrderStatus.sent
    save
  end
end
