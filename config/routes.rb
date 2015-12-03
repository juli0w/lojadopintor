Rails.application.routes.draw do
  root 'home#index'

  devise_for :users, path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register' }

  resources :users

  get 'profile' => 'users#edit'
  get 'search' => 'products#search'
  get 'contact' => 'messages#new'

  resources :messages, only: [:new, :create]

  post 'calculate_shipping_price' => 'carts#calculate_shipping_price'
  post 'apply_coupon' => 'carts#apply_coupon'

  resources :categories, only: :show
  resources :products, only: [:index, :show]
  resource :cart, only: [:show]
  resources :order_items, only: [:create, :update, :destroy]
  resources :orders do
    collection do
      get :confirm
      post :shipping
      post :finish
    end
  end

  namespace :admin do
    root 'dashboard#index'
    resources :dashboard, only: :index
    resources :products
    resources :coupons
    resources :orders do
      member do
        put :change
      end
    end
    resources :users
    resources :categories do
      collection do
        get :importation
        post :import
        delete :format
      end
    end
  end
end
