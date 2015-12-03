class UsersController < ApplicationController
  before_filter :authenticate_user!

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(user_params)
      redirect_to profile_path, notice: "Atualizado com sucesso."
    else
      render :edit
    end
  end

private

  def user_params
    params.require(:user).permit(:name, :phone, :cellphone, :address, :uf, :city, :cep)
  end
end
