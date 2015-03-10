module Seeder
  class WebLayoutSeeder < Seeder::ModelSeeder
    attr_reader :instructions, :template, :website

    def initialize(template, instructions)
      @template = template
      @instructions = instructions
    end

    def seed
      raise SyntaxError unless has_valid_instructions?
      @template.create_web_layout(layout_params)
      @template
    end

    private

    def has_valid_instructions?
      @website_template && @instructions &&
      @instructions.has_key?(:slug)
    end

    def layout_params
      params_for(GardenWebLayout, @instructions, :garden_web_layout_id)
    end
  end
end