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
        LOGGERS.each{|logger| logger.debug("\n\n########################################### Website ######\n")}
        compile_directory.find_or_make_dir
        clean_up
        LOGGERS.each{|logger| logger.debug("Starting javascripts.compile for website")}
        LOGGERS.each{|logger| logger.debug("finished javascripts.compile")}
        LOGGERS.each{|logger| logger.debug("Starting stylesheets.compile for website")}
        stylesheets.compile
        LOGGERS.each{|logger| logger.debug("finished stylesheets.compile")}
        LOGGERS.each{|logger| logger.debug("########## Beginning WEB_HOME compile")}
        web_home_template.compile
        LOGGERS.each{|logger| logger.debug("########## Finished WEB_HOME compile")}
        web_page_templates.compile
        area_pages.compile if website.owner.corporate?
        htaccess.compile
        sitemap.compile
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
        AreaPages.new(website.compile_path, ::Location.live_websites)
      end

      def htaccess
        @htaccess ||= HTAccess.new(website)
      end

      def sitemap
        @sitemap ||= Sitemap.new(website)
      end

      def robots
        @robots ||= Robots.new(website)
      end
    end
  end
end
