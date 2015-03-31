class WebsiteDecorator < Draper::Decorator
  delegate_all
  decorates_association :web_home_template
  decorates_association :web_page_template

  liquid_methods :heroku_url

  def github_repo
    "git@github.com:G5/static-heroku-app.git"
  end

  def heroku_app_name
    return model.urn[0..29].gsub(/\A[-\.]+|[-\.]+\z/, "") unless single_domain_location?

    client.website.urn[0..29].gsub(/\A[-\.]+|[-\.]+\z/, "")
  end

  def domain
    owner.domain if owner
  end

  def heroku_repo
    "git@heroku.com:#{heroku_app_name}.git"
  end

  def heroku_url
    if single_domain_location? && !corporate?
      "#{heroku_url_base}/#{single_domain_location_path}"
    else
      heroku_url_base
    end
  end

  def heroku_url_base
    "http://#{heroku_app_name}.herokuapp.com"
  end

  def url
    if single_domain_location?
      single_domain_location_path + "singledomainlocationpath"
    else
      domain || heroku_url
    end
  end

end

