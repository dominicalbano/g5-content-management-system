
module Seeder
  class WebThemeSeeder < Seeder::ModelSeeder
    attr_reader :instructions, :template, :website

    def initialize(template, instructions)
      @template = template
      @instructions = instructions
    end

    def seed
      raise SyntaxError unless has_valid_instructions?
      @template.create_web_theme(theme_params)
      @template
    end
    
    private

    def has_valid_instructions?
      @template && @instructions &&
      @instructions.has_key?(:slug)
    end

    def theme_params
      params_for(GardenWebTheme, @instructions, :garden_web_theme_id)
    end
  end
end