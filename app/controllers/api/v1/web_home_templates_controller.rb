class Api::V1::WebHomeTemplatesController < Api::V1::BaseController
  protected

  def klass_params
    params.require(:web_home_template).permit(:website_id, :name, :title, :enabled, :redirect_patterns)
  end
end
