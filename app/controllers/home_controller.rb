class HomeController < ApplicationController
  def index
    @line_products = LineProduct.all
  end

  def stores
  end
end
