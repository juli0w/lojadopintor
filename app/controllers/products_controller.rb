class ProductsController < ApplicationController
  def index
    load_products
  end

  def show
    load_order
    @product = Product.friendly.find(params[:id])
  end

  def search
    @products = Product.where("name like ?", "%#{params[:q]}%").page(params[:page])
  end
end
