class UpdateNavigationSettingsJob
  extend HerokuResqueAutoscaler if Rails.env.production?
  @queue = :update_navigation_settings

  def self.perform(website_id)
    #Website.find(website_id).try(:update_navigation_settings)
    sleep 5
  end
end