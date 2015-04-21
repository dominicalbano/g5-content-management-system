class Api::V1::WebPageTemplatesController < Api::V1::BaseController
  def create
    @web_page_template = klass.new(klass_params)
    @main_drop_target = @web_page_template.drop_targets.build(html_id: "drop-target-main")

    if @web_page_template.save && @main_drop_target.save
      render json: @web_page_template
    else
      render json: @web_page_template.errors, status: :unprocessable_entity
    end
  end

  def destroy
    web_page_template = klass.find(params[:id])
    Resque.enqueue(WebTemplateDestroyerJob, web_page_template.id)
    render json: nil, status: :ok
  end

  def options
    render json: {}
  end

  private

  def klass_params
    params.require(:web_page_template).permit(:website_id, :name, :title,
      :enabled, :display_order_position, :redirect_patterns, :in_trash, :parent_id)
  end
end
