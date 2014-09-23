class LocationSerializer < ActiveModel::Serializer
  embed :ids, include: true

  # This previously included the website association but that generated too many subsequent
  # associations so it was removed. Leaving this comment here just to remember the history. 

  attributes  :id,
              :urn,
              :name,
              :domain,
              :corporate,
              :single_domain,
              :website_heroku_url,
              :website_slug

  def single_domain
    Client.first.type == "SingleDomainClient"
  end

  def website_slug
    object.website.slug
  end

  def website_heroku_url
    object.website.decorate.heroku_url
  end

end
