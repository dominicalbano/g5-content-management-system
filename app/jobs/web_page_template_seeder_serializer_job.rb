class WebPageTemplateSeederSerializerJob
  extend HerokuResqueAutoscaler if Rails.env.production?
  @queue = :seeder_serializer

  def self.perform
    Client.first.locations.each do |l|
      next unless l && l.website
      WebPageTemplateSeederSerializer.new(l.website.web_home_template).to_yaml_file
      l.website.web_page_templates.each do |p|
        WebPageTemplateSeederSerializer.new(p).to_yaml_file
      end
    end
  end
end
