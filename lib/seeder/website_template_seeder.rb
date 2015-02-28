module Seeder
  class WebsiteTemplateSeeder < Seeder::ModelSeeder
    attr_reader :instructions, :template, :website

    def initialize(website, instructions)
      @website = website
      @instructions = instructions
    end

    def seed
      @website.create_website_template(website_template_params)
    end

    private

    def website_template_params
      ActionController::Parameters.new(@instructions).permit(:name, :title)
    end
  end
end