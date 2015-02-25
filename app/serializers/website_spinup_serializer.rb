class WebsiteSpinupSerializer < ActiveModel::Serializer
  def as_json(options=nil)
    { website_template: WebsiteTemplateSpinupSerializer.new(object.website_template, {root: false}).as_json }
  end
end
