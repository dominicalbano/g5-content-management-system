class StaticWebsiteDeployerJob
  extend HerokuResqueAutoscaler if Rails.env.production?
  @queue = :static_website_deployer

  def self.perform(website_urn, user_email)
    new(website_urn, user_email).perform
  end

  def initialize(website_urn, user_email)
    @website = Website.find_by_urn(website_urn).decorate
    @user_email = user_email
  end

  def perform
    StaticWebsite.compile_and_deploy(@website, @user_email)
  end
end

