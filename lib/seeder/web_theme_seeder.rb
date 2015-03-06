
module Seeder
  class WebThemeSeeder < Seeder::ModelSeeder
    attr_reader :instructions, :template, :website

    def initialize(website, template, instructions)
      @website = website
      @template = template
      @instructions = instructions
    end

    def seed
      @template.create_web_theme(theme_params)
      @template
    end
    
    private

    def theme_params
      params_for(GardenWebTheme, @instructions, :garden_web_theme_id)
    end
  end
end