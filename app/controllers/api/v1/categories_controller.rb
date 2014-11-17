class Api::V1::CategoriesController < Api::V1::ApplicationController
  def index
    render json: Category.all
  end
end
