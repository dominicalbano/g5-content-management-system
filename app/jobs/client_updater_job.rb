class ClientUpdaterJob
  extend HerokuResqueAutoscaler if Rails.env.production?
  @queue = :updater

  def self.perform
    ClientReaderJob.perform(ENV["G5_CLIENT_UID"])
    WebsiteSeederJob.perform
  end
end
