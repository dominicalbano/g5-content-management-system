require "client_deployer/compile_directory"
require "client_deployer/website_compiler/javascripts"
require "client_deployer/website_compiler/stylesheets"
require "client_deployer/website_compiler/web_template"
require "client_deployer/website_compiler/web_templates"

module ClientDeployer
  module WebsiteCompiler
    class Website
      def initialize(website)
        @website = website
        @compile_path = website.compile_path
      end

      def compile
        compile_directory.compile
        javascripts.compile
        stylesheets.compile
        web_home_template.compile
        web_page_templates.compile
      end

    private

      def compile_directory
        @compile_directory ||= ClientDeployer::CompileDirectory.new(@compile_path, false)
      end

      def javascripts
        @javascripts ||= Javascripts.new(@website.javascripts, @compile_path, location_name)
      end

      def stylesheets
        @stylesheets ||= Stylesheets.new(@website.stylesheets, @compile_path, @website.colors, location_name)
      end

      def location_name
        @website.name
      end

      def web_home_template
        @web_home_template ||= WebTemplate.new(@website.web_home_template)
      end

      def web_page_templates
        @web_page_templates ||= WebTemplates.new(@website.web_page_templates)
      end
    end
  end
end
