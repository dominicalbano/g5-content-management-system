class ClientUpdaterJob
  extend HerokuResqueAutoscaler if Rails.env.production?
  @queue = :updater

  def self.perform(force_seed=false)
    ClientReader.new(ENV["G5_CLIENT_UID"]).perform

    Location.all.each do |location|
      Seeder::WebsiteSeeder.new(location).seed unless (!force_seed && location.website.present?)
    end
  end
end

