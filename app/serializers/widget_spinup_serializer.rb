class WidgetSpinupSerializer < ActiveModel::Serializer
  attributes  :slug
     
  def as_json(options=nil)
    if object
      return ContentStripeWidgetSpinupSerializer.new(object, {root: false}).as_json if object.kind_of_widget?('Content Stripe')
      return ColumnWidgetSpinupSerializer.new(object, {root: false}).as_json if object.kind_of_widget?('Column')
      return { slug: object.slug }
    end
  end
end
