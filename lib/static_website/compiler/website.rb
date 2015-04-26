require "static_website/compiler/compile_directory"
require "static_website/compiler/javascripts"
require "static_website/compiler/stylesheets"
require "static_website/compiler/web_template"
require "static_website/compiler/web_templates"
require "static_website/compiler/area_pages"
require "static_website/compiler/htaccess"
require "static_website/compiler/sitemap"
require "static_website/compiler/robots"
require "client_deployer/base_compiler/htaccess"
require "client_deployer/base_compiler/robots"
require "client_deployer/base_compiler/sitemap"

module StaticWebsite
  module Compiler
    class Website
      attr_reader :website, :compile_path

      def initialize(website)
        @website = website
        @compile_path = website.compile_path
      end

      def compile
        LOGGERS.each{|logger| logger.info("Static Website Compiler: Location: #{location_name}")}
        compile_directory.clean_up
        stylesheets.compile
        CompileDirectory.new(File.join(compile_path, "stylesheets")).clean_up
        web_home_template.compile
        web_page_templates.compile
        htaccess.compile
        robots.compile
        area_pages.compile if website.owner.corporate?
        #TODO: Sitemap *should* be updated any time single domain location is deployed.
        #      But this would remove all area pages from sitemap. So for now we only
        #      publish sitemap on single domain location when that location is corporate.
        sitemap.compile unless website.single_domain_location? and !website.owner.corporate?
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
        if website.single_domain_location?
          @htaccess ||= ClientDeployer::BaseCompiler::HTAccess.new(client)
        else
          @htaccess ||= StaticWebsite::Compiler::HTAccess.new(website)
        end
      end

      def sitemap
        if website.single_domain_location?
          @sitemap ||= ClientDeployer::BaseCompiler::Sitemap.new(client, area_page_directories)
        else
          @sitemap ||= StaticWebsite::Compiler::Sitemap.new(website, area_page_directories)
        end
      end

      def robots
        if website.single_domain_location?
          @robots ||= ClientDeployer::BaseCompiler::Robots.new(client)
        else
          @robots ||= StaticWebsite::Compiler::Robots.new(website)
        end
      end

      def client
        @client ||= Client.first
      end
    end
  end
end

