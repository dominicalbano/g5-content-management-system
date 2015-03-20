class Api::V1::Seeders::ContentStripesController < Api::V1::Seeders::SeederController
  def serializer
    ContentStripeWidgetSeederSerializer
  end

  def create
    # create cs from params
  end
  def update
    #render json: Location.find(params[:id])
  end
end
