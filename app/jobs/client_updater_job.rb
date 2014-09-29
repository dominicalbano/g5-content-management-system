class ClientUpdaterJob
  extend HerokuResqueAutoscaler if Rails.env.production?
  @queue = :updater

  def self.perform
    ClientReader.new(ENV["G5_CLIENT_UID"]).perform
    WebsiteSeederJob.perform
  end
end
