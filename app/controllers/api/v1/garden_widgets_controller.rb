class Api::V1::GardenWidgetsController < Api::V1::ApplicationController
  def index
    render json: GardenWidget.all
  end

  def update
    Resque.enqueue(GardenWidgetUpdaterJob)
    render json: {message: "Widget Garden Queued For Update."}
  end
end
