# encoding: UTF-8
module Admin
  class CouponsController < ApplicationController
    layout 'admin/application'

    def index
      @coupons = Coupon.all
    end

    def show
      @coupon = Coupon.find(params[:id])
    end

    def new
      @coupon = Coupon.new
    end

    def create
      @coupon = Coupon.new(coupon_params)

      if @coupon.save
        redirect_to admin_coupons_path, notice: 'Cupom criado com sucesso.'
      else
        render :new
      end
    end

    def edit
      @coupon = Coupon.find(params[:id])
    end

    def update
      @coupon = Coupon.find(params[:id])

      if @coupon.update_attributes(coupon_params)
        redirect_to admin_coupons_path, notice: 'Cupom atualizado com sucesso.'
      else
        render :edit
      end
    end

    def destroy
      @coupon = Coupon.find(params[:id])
      @coupon.active = false
      @coupon.save

      redirect_to admin_coupons_path
    end

    private

    def coupon_params
      params.require(:coupon).permit(:name, :owner_id, :expire_at, :active, :discount_type, :value)
    end
  end
end
