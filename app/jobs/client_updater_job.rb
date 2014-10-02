class ClientUpdaterJob
  extend HerokuResqueAutoscaler if Rails.env.production?
  @queue = :updater

  def self.perform
    @retries = 0

    ClientReader.new(ENV["G5_CLIENT_UID"]).perform

    Location.all.each do |location|
      next if location.website.present?
      WebsiteSeeder.new(location).seed
    end
  rescue
    @retries += 1
    Resque.enqueue(ClientUpdaterJob) if @retries < 4
  end
end
