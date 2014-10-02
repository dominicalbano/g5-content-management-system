class ClientUpdaterJob
  extend HerokuResqueAutoscaler if Rails.env.production?
  @queue = :updater

  def self.perform
    ClientReader.new(ENV["G5_CLIENT_UID"]).perform

    Location.all.each do |location|
      next if location.website.present?
      WebsiteSeeder.new(location).seed
    end
  end
end
