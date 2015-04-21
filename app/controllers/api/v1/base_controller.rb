class Api::V1::BaseController < Api::V1::ApplicationController
  def index
    render json: klass.all
  end

  def show
    render json: klass.find(params[:id])
  end

  def update
    item = klass.find(params[:id])
    if item.update_attributes(klass_params)
      render json: item
    else
      render json: item.errors, status: :unprocessable_entity
    end
  end

  protected

  def klass
    raise NotImplementedError
  end

  def klass_params
    raise NotImplementedError
  end
end
