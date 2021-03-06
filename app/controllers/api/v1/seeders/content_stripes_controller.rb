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

  def widget
    # option 1: select CS by widget id
    if params[:id].try(:to_i) > 0
      w = Widget.find(params[:id])
      return w.try(:is_content_stripe?) ? w : nil
    end
    
    # option 2: select CS by index param on page matching slug param
    # - example:  params = { slug: 'apply', index: 2 }
    index = params[:index].try(:to_i) || 1
    cs = web_template.widgets.select { |w| w.is_content_stripe? } if web_template
    if (cs && cs.size >= index)
      return cs[index-1] if cs[index-1].is_content_stripe?
    end
  end
end
