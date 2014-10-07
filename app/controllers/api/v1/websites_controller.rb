class Api::V1::WebsitesController < Api::V1::ApplicationController
  def index
    render json: Website.all
  end

  def show
    render json: Website.find(params[:id])
  end
end
