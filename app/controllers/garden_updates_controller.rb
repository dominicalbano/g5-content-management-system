class GardenUpdatesController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_before_filter :verify_authenticity_token

  GARDEN_UPDATE_JOBS = {
    garden_web_layout: GardenWebLayoutUpdaterJob,
    garden_web_theme:  GardenWebThemeUpdaterJob,
    garden_widget:     GardenWidgetUpdaterJob
  }

  def update
    Resque.enqueue(GARDEN_UPDATE_JOBS[params[:id].to_sym])
    render json: {}, status: :ok
  end
end
