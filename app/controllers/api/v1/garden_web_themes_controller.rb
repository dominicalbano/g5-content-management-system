class Api::V1::GardenWebThemesController < Api::V1::ApplicationController
  def index
    render json: GardenWebTheme.all
  end

  def update
    Resque.enqueue(GardenWebThemeUpdaterJob)
    render json: {message: "Theme Garden Queued For Update."}
  end
end
