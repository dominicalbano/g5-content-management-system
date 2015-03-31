class Api::V1::WidgetsController < Api::V1::ApplicationController
  def index
    render json: Widget.find(params[:ids])
  end

  def show
    render json: Widget.find(params[:id]), root: klass
  end

  def create
    @widget = Widget.new(widget_params)
    if @widget.save
      render json: @widget, root: klass
    else
      render json: @widget.errors, root: klass, status: :unprocessable_entity
    end
  end

  def update
    @widget = Widget.find(params[:id])
    if @widget.update_attributes(widget_params)
      render json: @widget, root: klass
    else
      render json: @widget.errors, root: klass, status: :unprocessable_entity
    end
  end

  def destroy
    @widget = Widget.find(params[:id])
    if @widget.destroy
      render json: nil, status: :ok
    else
      render json: @widget.errors, root: klass, status: :unprocessable_entity
    end
  end

  def options
    render json: {}
  end

  private

  def widget_params
    # TODO: remove when Ember App implements DropTarget
    web_template_id ||= params[klass][:website_template_id]
    web_template_id ||= params[klass][:web_home_template_id]
    web_template_id ||= params[klass][:web_page_template_id]
    web_template = WebTemplate.find(web_template_id) if web_template_id
    drop_target = web_template.drop_targets.find_by_html_id(section) if web_template
    params[klass][:drop_target_id] ||= drop_target.id if drop_target
    params.require(klass).permit(:garden_widget_id, :drop_target_id, :display_order_position)
  end

  def klass
    "widget"
  end

  def section
    "drop-target-#{klass.split("_widget").first.dasherize}"
  end
end
