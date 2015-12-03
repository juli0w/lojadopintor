# encoding: UTF-8
class OrdersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_empty, only: [:confirm, :setup]

  def check_empty
    if current_order.order_items.empty?
      redirect_to cart_path, notice: "Adicione itens ao carrinho"
    end
  end

  def confirm
    @order = current_order
    @order.load_from_profile(current_user)
  end

  def shipping
    @order = current_order

    if @order.update_attributes(order_params)
      @shipping_methods = @order.extract_shipping_prices

      if @order.shipping_error?
        @order.errors[:base] << "Ocorreu algum erro, por favor verifique o formulário"
        render :confirm
      end
    else
      render :confirm
    end
  end

  def finish
    @order = current_order

    if @order.update_attributes(shipping_method: params[:shipping_method]) and @order.setup!(current_user.id)
      reset_session
      redirect_to @order
    else
      render :confirm
    end
  end

  def cancel
    @order = current_user.orders.where(id: params[:id]).first

    @order.cancel!
    redirect_to @order, notice: "Pedido cancelado."
  end

  def pay
    @order = current_user.orders.where(id: params[:id]).first

    # TO DO
  end

  def index
    @orders = current_user.orders.order("created_at DESC")
  end

  def show
    @order = current_user.orders.find(params[:id])
    @order_items = @order.order_items
  end

private

  def order_params
    params.require(:order).permit(:customer_name, :customer_phone, :customer_cellphone, :shipping_address, :shipping_uf, :shipping_city, :shipping_cep)
  end
end
