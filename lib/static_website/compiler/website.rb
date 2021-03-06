require "static_website/compiler/compile_directory"
require "static_website/compiler/javascripts"
require "static_website/compiler/stylesheets"
require "static_website/compiler/web_template"
require "static_website/compiler/web_templates"
require "static_website/compiler/area_pages"
require "static_website/compiler/htaccess"
require "static_website/compiler/sitemap"
require "static_website/compiler/robots"

module StaticWebsite
  module Compiler
    class Website
      attr_reader :website, :compile_path

      def initialize(website)
        @website = website
        @compile_path = website.compile_path
      end

      def compile
        compile_directory.compile
        clean_up
        stylesheets.compile
        web_home_template.compile
        web_page_templates.compile
        area_pages.compile if website.owner.corporate?
        Sitemap.new(website, area_page_directories).compile
        htaccess.compile
        robots.compile
      end

      def clean_up
        compile_directory.clean_up
      end

      def compile_directory
        @compile_dictory ||= CompileDirectory.new(compile_path)
      end

      def javascripts
        @javascripts ||= Javascripts.new(website.javascripts, compile_path, location_name)
      end

      def stylesheets
        @stylesheets ||= Stylesheets.new(website.stylesheets, compile_path, website.colors, website.fonts, location_name)
      end

      def location_name
        website.name
      end

      def web_home_template
        @web_home_template ||= WebTemplate.new(website.web_home_template)
      end

      def web_page_templates
        @web_page_templates ||= WebTemplates.new(website.web_page_templates)
      end

      def area_pages
        @area_pages ||= AreaPages.new(website.compile_path, ::Location.for_area_pages.map(&:website))
      end

      def area_page_directories
        area_pages.pages.map {|area_page| area_page.sub("/index.html",'')}.uniq
      end

      def htaccess
        @htaccess ||= HTAccess.new(website)
      end

      def sitemap
      end

      def robots
        @robots ||= Robots.new(website)
      end
    end
  end
end

