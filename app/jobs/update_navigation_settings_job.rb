class UpdateNavigationSettingsJob
  extend HerokuResqueAutoscaler if Rails.env.production?
  @queue = :update_navigation_settings

  def self.perform(website_id)
    Rails.logger.debug("ID IS #{website_id},  website is #{Website.find(website_id)}")
    Website.find(website_id).try(:update_navigation_settings)
  end
end