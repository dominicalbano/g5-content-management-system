class ContentStripeWidgetSeederJob
  extend HerokuResqueAutoscaler if Rails.env.production?
  @queue = :content_stripe_seeder

  def self.perform(web_template, instructions=nil)
    self.new(web_template, is_home).perform if web_template
  end

  def initialize(web_template, instructions)
    @web_template = web_template
    @drop_target = web_template.drop_targets.find_by_html_id('drop-target-main')
    @instructions = instructions
  end

  def perform
    Seeder::ContentStripeWidgetSeeder.new(@drop_target, @instructions).seed
  end
end
