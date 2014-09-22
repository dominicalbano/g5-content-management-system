class DeployTasks
  extend HerokuResqueAutoscaler if Rails.env.production?
  @queue = :deploy_tasks

  def self.perform(client_uid)
    ClientReader.new(client_uid).perform
    GardenWebLayoutUpdater.new.update_all
    GardenWebThemeUpdater.new.update_all
    GardenWidgetUpdater.new.update_all

    WebsiteSeederJob.perform
  end
end
