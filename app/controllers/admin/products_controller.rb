module Admin
  class ProductsController < ApplicationController
    layout 'admin/application'

    def index
      @products = Product.page(params[:page]).per(40)
    end

    def new
      @product = Product.new
      @line_products = LineProduct.all
      @categories = Category.all
    end

    def create
      @product = Product.new(product_params)
      if @product.save
        redirect_to [:admin, :products], notice: "Cadastrado com sucesso."
      else
        render :new
      end
    end

    def edit
      @product = Product.friendly.find(params[:id])
      @line_products = LineProduct.all
      @categories = Category.all
    end

    def update
      @product = Product.friendly.find(params[:id])
      if @product.update_attributes(product_params)
        redirect_to [:admin, :products], notice: "Atualizado com sucesso."
      else
        render :edit
      end
    end

  private

    def product_params
      params.require(:product).permit(:line_product_id, :name, :price, :active, :description, :excerpt, :tax, :tag_list, :image, :category_id, :width, :height, :depth, :weight)
    end
  end
end
