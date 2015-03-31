class GardenUpdatesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  unless Rails.env.development?
    before_filter :authenticate_api_user!, if: :is_api_request?
    before_filter :authenticate_user!, unless: :is_api_request?
  end

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
