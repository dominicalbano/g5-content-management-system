class DeployTasks
  extend HerokuResqueAutoscaler if Rails.env.production?
  @queue = :deploy_tasks

  def self.perform(client_uid)
    # ClientReaderJob must be performed before WebsiteSeeder
    ClientReaderJob.perform(client_uid)
    # GardenWebLayoutUpdaterJob must be performed before WebsiteSeeder
    GardenWebLayoutUpdaterJob.perform
    # GardenWebThemetUpdaterJob must be performed before WebsiteSeeder
    GardenWebThemeUpdaterJob.perfom
    # GardenWidgetUpdaterJob must be performed before WebsiteSeeder
    GardenWidgetUpdaterJob.perfom
    # WebsiteSeederJob must be performed last
    WebsiteSeederJob.perform
  end
end
