class ClientUpdaterJob
  extend HerokuResqueAutoscaler if Rails.env.production?
  @queue = :updater

  def self.perform
    tries ||= 3

    ClientReader.new(ENV["G5_CLIENT_UID"]).perform

    Location.all.each do |location|
      next if location.website.present?
      WebsiteSeeder.new(location).seed
    end
  rescue
    retry unless (tries -= 1).zero?
  end
end
