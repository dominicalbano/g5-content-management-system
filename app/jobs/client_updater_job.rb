class ClientUpdaterJob
  extend HerokuResqueAutoscaler if Rails.env.production?
  @queue = :updater

  def self.perform
    ClientReader.new(client_uid).perform
    WebsiteSeederJob.perform
  end
end
