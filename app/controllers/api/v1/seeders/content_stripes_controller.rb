class Api::V1::Seeders::ContentStripesController < Api::V1::Seeders::SeederController
  ##TODO: remove this! need to work with Maeve to make my POST requests work
  skip_before_filter :authenticate_api_user!

  def serializer
    ContentStripeWidgetSeederSerializer
  end

  def seeder
    ContentStripeWidgetSeederJob
  end

  def serializer_object
    @object ||= widget
  end

  def seeder_object
    @object ||= web_template
  end

  private

  def widget
    w = Widget.find(params[:id]) if params[:id].try(:to_i) > 0
    return w if w.try(:is_content_stripe?)
    index = params[:index].try(:to_i) || 1
    cs = web_template.widgets.select { |w| w.is_content_stripe? } if web_template
    return cs[index] if (cs && cs.size > index)
  end
end
