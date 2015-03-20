class Api::V1::Seeders::WebPageTemplatesController < Api::V1::Seeders::SeederController
  def serializer
    WebPageTemplateSeederSerializer
  end
  
  def create
    # create page from params
  end
  def update
    #render json: Location.find(params[:id])
  end
end
