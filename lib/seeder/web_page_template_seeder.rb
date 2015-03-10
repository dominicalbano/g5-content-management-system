module Seeder
  class WebPageTemplateSeeder < Seeder::ModelSeeder
    attr_reader :instructions, :website, :is_home

    def initialize(website, instructions, is_home=false)
      @instructions = instructions
      @website = website
      @is_home = is_home
    end

    def seed
      Rails.logger.debug("Creating web #{@is_home ? 'home' : 'page'} template from instructions")
      raise SyntaxError unless is_valid_instructions?
      template = @is_home ? @website.create_web_home_template(web_page_template_params) : @website.web_page_templates.create(web_page_template_params)
      DropTargetSeeder.new(template, @instructions[:drop_targets]).seed
      template
    end

    private

    def is_valid_instructions?
      @website && @instructions &&
      @instructions.has_key?(:name) &&
      @instructions.has_key?(:drop_targets)
    end

    def web_page_template_params
      ActionController::Parameters.new(@instructions).permit(:name, :title)
    end
  end
end