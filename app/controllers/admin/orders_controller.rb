module Admin
  class OrdersController < ApplicationController
    layout 'admin/application'

    def index
      @orders = Order.filter(params[:state]).order("created_at DESC")
    end

    def show
      @order = Order.find(params[:id])
      @order_items = @order.order_items
    end

    def change
      @order = Order.find(params[:id])

      if %w(pay send cancel).include?(params[:state])
        @order.send("#{params[:state]}!")
      end

      redirect_to [:admin, @order], notice: "Alterado com sucesso."
    end
  end
end
