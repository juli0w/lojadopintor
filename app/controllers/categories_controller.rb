class CategoriesController < ApplicationController
  def show
    load_products
    @category = Category.friendly.find(params[:id])
    @products = @products.where(category_id: @category.id)
  end
end
