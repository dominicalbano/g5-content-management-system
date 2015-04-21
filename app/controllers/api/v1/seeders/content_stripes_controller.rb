class Api::V1::Seeders::ContentStripesController < Api::V1::Seeders::SeederController
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

  def seeder_params
    { urn: @object.owner.urn, slug: @object.slug } if seeder_object
  end

  private

  def is_content_stripe?(cs)
    cs.try(:kind_of_widget?, 'content-stripe')
  end

  def widget
    # option 1: select CS by widget id
    return get_widget_by_id(params[:id]) if params[:id].try(:to_i) > 0
    
    # option 2: select CS by index param on page matching slug param
    index = params[:index].try(:to_i) || 1
    get_widget_by_index(index)
  end

  def get_widget_by_id(id)
    w = Widget.find(id)
    is_content_stripe?(w) ? w : nil
  end

  def get_widget_by_index(index)
    cs = web_template.widgets.select { |w| is_content_stripe?(w) } if web_template
    if (cs && cs.size >= index)
      return cs[index-1] if is_content_stripe?(cs[index-1])
    end
  end
end
