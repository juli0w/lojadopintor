class HomeController < ApplicationController
  def index
    @line_products = LineProduct.all
  end
end
