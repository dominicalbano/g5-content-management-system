class Api::V1::CategoriesController < Api::V1::ApplicationController
  def index
    render json: Category.all
  end

  def show
    render json: Category.find(params[:id]), root: :category
  end
end
