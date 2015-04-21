class Api::V1::WebThemesController < Api::V1::BaseController
  protected

  def klass_params
    params.require(:web_theme).permit(:garden_web_theme_id, :custom_colors, :primary_color, :secondary_color, :tertiary_color, :custom_fonts, :primary_font, :secondary_font)
  end
end
