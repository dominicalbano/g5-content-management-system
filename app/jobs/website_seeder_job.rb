class WebsiteSeederJob
  extend HerokuResqueAutoscaler if Rails.env.production?
  @queue = :website_seeder

  def self.perform(urn=nil, instructions=nil)
    locations = urn.blank? ? Location.all : Location.where("urn = ?", urn)
    locations.each do |l|
      next if l.website.present? && urn.blank?
      self.new(l, instructions).perform
    end
  end

  def initialize(loc, instructions)
    @location = loc
    @instructions = instructions
  end

  def perform
    Seeder::WebsiteSeeder.new(@location, @instructions).seed
  end
end
