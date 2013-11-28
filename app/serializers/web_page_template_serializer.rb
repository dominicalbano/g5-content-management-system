class WebPageTemplateSerializer < WebTemplateSerializer
  embed :ids, include: true

  has_many :main_widgets

  attributes :preview_url,
             :name,
             :title,
             :disabled,
             :slug,
             :display_order

  def preview_url
    web_template_url(object)
  end

  def slug
    object.name.parameterize
  end
end
