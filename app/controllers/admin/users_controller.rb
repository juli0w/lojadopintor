module Admin
  class UsersController < ApplicationController
    layout 'admin/application'

    def index
      @users = User.all
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      if @user.save
        redirect_to [:admin, :users], notice: "Cadastrado com sucesso."
      else
        render :new
      end
    end

    def edit
      @user = User.find(params[:id])
    end

    def update
      @user = User.find(params[:id])
      if @user.update_attributes(user_params)
        redirect_to [:admin, :users], notice: "Atualizado com sucesso."
      else
        render :edit
      end
    end

  private

    def user_params
      params.require(:user).permit(:name, :phone, :cellphone, :address, :uf, :city, :cep, :password, :password_confirmation, :email)
    end
  end
end
