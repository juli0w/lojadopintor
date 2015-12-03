class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_order
  after_filter :store_location
  before_filter :load_nav

  def load_nav
    @categories_root = Category.roots
  end

  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    return unless request.get?
    if (request.path != "/users/login" &&
        request.path != "/users/register" &&
        request.path != "/users/password/new" &&
        request.path != "/users/password/edit" &&
        request.path != "/users/confirmation" &&
        request.path != "/users/sign_out" &&
        request.path != "/users/logout" &&
        !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath
    end
  end

  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end

  def load_products_and_order
    load_products
    load_order
  end

  def load_order
    @order_item = current_order.order_items.new
  end

  def load_products
    @products = Product.order("active DESC").page(params[:page]).per(16)
  end

  def reset_session
    session[:order_id] = nil
  end

  def current_order
    unless session[:order_id].blank?
      Order.find(session[:order_id])
    else
      order = Order.create
      session[:order_id] = order.id
      order
    end
  end
end
