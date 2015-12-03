# encoding: UTF-8
class CartsController < ApplicationController
  def show
    @shipping_methods = current_order.extract_shipping_prices
    @order_items = current_order.order_items
    @coupon = current_order.coupon.try(:name)
    @discount = current_order.calculate_discount
    @subtotal = current_order.calculate_subtotal
    # @total = current_order.calculate_total
  end

  def calculate_shipping_price
    cep = params[:cep].tr('-', '')
    current_order.update_attributes(shipping_cep: cep) if cep.length == 8
    redirect_to cart_path
  end

  def apply_coupon
    if current_order.apply_coupon(params[:coupon])
      notice = "Cupom adicionado ao pedido"
    else
      notice = "Cupom inválido!"
    end

    redirect_to cart_path, notice: notice
  end
end
