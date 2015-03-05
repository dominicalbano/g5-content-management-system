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
      if @website && @instructions
        template = @is_home ? @website.create_web_home_template(web_page_template_params) : @website.web_page_templates.create(web_page_template_params)
        DropTargetSeeder.new(@website, template, @instructions[:drop_targets]).seed
      end
    end

    private

    def web_page_template_params
      ActionController::Parameters.new(@instructions).permit(:name, :title)
    end
  end
end