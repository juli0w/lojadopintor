# encoding: UTF-8
module Admin
  class CategoriesController < ApplicationController
    layout 'admin/application'

    def importation
    end

    def import
      if Category.import(params[:familias], params[:grupos], params[:subgrupos], params[:itens])
        redirect_to admin_categories_path, notice: "Categorias importadas"
      else
        redirect_to importation_admin_categories_path, notice: "Ocorreu algum erro, tente novamente."
      end
    end

    def index
      @categories_root = Category.roots
    end

    def new
      @category = Category.new
      @categories = Category.all
    end

    def create
      @category = Category.new(category_params)

      respond_to do |format|
        if @category.save
          format.html { redirect_to admin_categories_path, notice: 'Categoria criada com sucesso.' }
        else
          format.html { render :new }
        end
      end
    end

    def edit
      @category = Category.friendly.find(params[:id])
      @categories = Category.all
    end

    def update
      @category = Category.friendly.find(params[:id])

      respond_to do |format|
        if @category.update_attributes(category_params)
          format.html { redirect_to admin_categories_path, notice: 'Categoria atualizada com sucesso.' }
        else
          format.html { render :edit }
        end
      end
    end

    def format
      Category.delete_all

      redirect_to importation_admin_categories_path, notice: "Categorias deletadas"
    end

    private

    def category_params
      params.require(:category).permit(:name, :parent_id, :active)
    end
  end
end
