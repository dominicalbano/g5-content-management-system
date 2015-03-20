class Api::V1::Seeders::WebsitesController < Api::V1::Seeders::SeederController
  def serializer
    WebsiteSeederSerializer
  end

  def create
    # create website from params
  end
  def update
    #render json: Location.find(params[:id])
  end
end
