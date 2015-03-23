class WebPageTemplateSeederJob
  extend HerokuResqueAutoscaler if Rails.env.production?
  @queue = :web_page_template_seeder

  def self.perform(urn, instructions=nil, is_home=false)
    site = Location.find_by_urn(urn).try(:website)
    self.new(site, instructions, is_home).perform if site
  end

  def initialize(site, instructions, is_home=false)
    @website = site
    @instructions = instructions
    @is_home = is_home
  end

  def perform
    Seeder::WebPageTemplateSeeder.new(@website, @instructions, @is_home).seed
  end
end
