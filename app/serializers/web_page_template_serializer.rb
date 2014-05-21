class WebPageTemplateSerializer < WebTemplateSerializer
  embed :ids, include: true

  has_many :main_widgets

  attributes :preview_url,
             :name,
             :title,
             :enabled,
             :slug,
             :display_order,
             :redirect_patterns,
             :in_trash

  def preview_url
    if corporate?
      File.join(root_url, object.client.vertical_slug, location.state_slug, location.city_slug, object.slug)
    else
      File.join(root_url, object.url)
    end
  end

private

  def location
    website.owner
  end

  def website
    object.website
  end

  def corporate?
    website && website.corporate?
  end
end
