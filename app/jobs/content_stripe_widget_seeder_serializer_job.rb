class ContentStripeWidgetSeederSerializerJob
  extend HerokuResqueAutoscaler if Rails.env.production?
  @queue = :seeder_serializer

  def self.perform(location=nil, web_template=nil)
    locations = location ? [location] : Location.all
    locations.each do |l|
      l.website.web_page_templates.each do |p|
        p.widgets.content_stripe.each do |cs|
          ContentStripeWidgetSeederSerializer.new(cs).to_yaml_file
        end
      end if l && l.website
    end
  end
end
