class Api::V1::GardenWebLayoutsController < Api::V1::ApplicationController
  def index
    render json: GardenWebLayout.all
  end

  def update
    Resque.enqueue(GardenWebLayoutUpdaterJob)
    render json: {message: "Layout Garden Queued For Update."}
  end
end
