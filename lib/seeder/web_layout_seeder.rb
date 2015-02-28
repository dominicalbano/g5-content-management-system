module Seeder
  class WebLayoutSeeder < Seeder::ModelSeeder
    attr_reader :instructions, :template, :website

    def initialize(website, template, instructions)
      @website = website
      @template = template
      @instructions = instructions
    end

    def seed
      @template.create_web_layout(layout_params)
    end

    private

    def layout_params
      params_for(GardenWebLayout, @instructions, :garden_web_layout_id)
    end
  end
end