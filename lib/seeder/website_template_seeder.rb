module Seeder
  class WebsiteTemplateSeeder < Seeder::ModelSeeder
    attr_reader :instructions, :template, :website

    def initialize(website, instructions)
      @website = website
      @instructions = instructions
    end

    def seed
      @website.create_website_template(template_params)
    end
  end
end