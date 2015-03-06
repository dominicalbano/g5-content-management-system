module Seeder
  class WebsiteTemplateSeeder < Seeder::ModelSeeder
    attr_reader :instructions, :website, :website_template

    def initialize(website, instructions)
      @website = website
      @instructions = instructions
    end

    def seed
      raise SyntaxError unless has_valid_instructions?
      @website_template = @website.create_website_template(website_template_params)
      WebLayoutSeeder.new(@website, @website_template, @instructions[:web_layout]).seed
      WebThemeSeeder.new(@website, @website_template, @instructions[:web_theme]).seed
      DropTargetSeeder.new(@website, @website_template, @instructions[:drop_targets]).seed
      @website_template
    end

    private

    def has_valid_instructions?
      @instructions.has_key?(:web_layout) &&
      @instructions.has_key?(:web_theme) &&
      @instructions.has_key?(:drop_targets)
    end

    def website_template_params
      ActionController::Parameters.new(@instructions).permit(:name, :title)
    end
  end
end