class WidgetSeederSerializer < ActiveModel::Serializer
  attributes  :slug
     
  def as_json(options=nil)
    if object
      klass = "#{object.slug.underscore.classify}WidgetSeederSerializer".safe_constantize if object.name
      if klass
        klass.new(object, {root: false}).as_json
      else
        { slug: object.slug }
      end
    end
  end
end
