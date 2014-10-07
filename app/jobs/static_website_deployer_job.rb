class StaticWebsiteDeployerJob
  extend HerokuResqueAutoscaler if Rails.env.production?
  @queue = :static_website_deployer

  def self.perform(website_urn)
    new(website_urn).perform
  end

  def initialize(website_urn)
    @website = Website.find_by_urn(website_urn).decorate
  end

  def perform
    StaticWebsite.compile_and_deploy(@website)
  end
end
