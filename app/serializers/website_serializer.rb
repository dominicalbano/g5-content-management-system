class WebsiteSerializer < ActiveModel::Serializer
  embed :ids, include: true

  has_one :website_template
  has_one :web_home_template
  has_many :web_page_templates
  has_many :assets
  has_many :categories

  attributes  :id,
              :owner_id,
              :owner_type,
              :name,
              :urn,
              :slug,
              :heroku_url

  def heroku_url
    object.decorate.heroku_url
  end
  
end

