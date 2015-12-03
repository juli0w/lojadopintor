# encoding: UTF-8
module Admin
  class ApplicationController < ::ApplicationController
    before_filter :authenticate_user!
    before_filter :authenticate_admin!

    def authenticate_admin!
      if !current_user || !current_user.admin?
        redirect_to root_path, notice: 'Sem permissão.'
      end
    end
  end
end
