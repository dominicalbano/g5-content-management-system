class ContentStripeWidgetSeederJob
  extend HerokuResqueAutoscaler if Rails.env.production?
  @queue = :content_stripe_seeder

  def self.perform(params, instructions=nil)
    urn = params ? params['urn'] : nil
    slug = params ? params['slug'] : nil
    site = Location.find_by_urn(urn).try(:website) unless urn.blank?
    web_template = site.web_templates.find_by_slug(slug) if (site && !slug.blank?)
    self.new(web_template, instructions).perform if web_template
  end

  def initialize(web_template, instructions)
    @web_template = web_template
    @drop_target = web_template.drop_targets.find_by_html_id('drop-target-main')
    @instructions = instructions
  end

  def perform
    Seeder::WidgetSeeder.new(@drop_target, @instructions).seed
  end
end
