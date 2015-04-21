class Api::V1::WebLayoutsController < Api::V1::BaseController
  protected

  def klass_params
    params.require(:web_layout).permit(:garden_web_layout_id)
  end
end
