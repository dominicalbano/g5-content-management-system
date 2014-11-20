class Api::V1::WebThemesController < Api::V1::ApplicationController
  def show
    render json: WebTheme.find(params[:id])
  end

  def update
    @web_theme = WebTheme.find(params[:id])
    if @web_theme.update_attributes(web_theme_params)
      render json: @web_theme
    else
      render json: @web_theme.errors, status: :unprocessable_entity
    end
  end

  private

  def web_theme_params
    params.require(:web_theme).permit(:garden_web_theme_id, :custom_colors, :primary_color, :secondary_color, :tertiary_color)
  end
end
