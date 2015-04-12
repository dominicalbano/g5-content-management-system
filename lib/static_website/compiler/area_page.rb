module StaticWebsite
  module Compiler
    class AreaPage
      def initialize(base_path, slug, params)
        @base_path = base_path
        @slug = slug
        @params = params
      end

      def compile
        compile_directory.compile
        LOGGERS.each {|logger| logger.info("calling render_to_file")}
        render_to_file
      end

      def compile_directory
        @compile_directory ||= CompileDirectory.new(compile_path, false)
      end

      def render_to_file
        LOGGERS.each {|logger| logger.info("opening compile_path #{compile_path}")}
        open(compile_path, "wb") do |file|
          LOGGERS.each {|logger| logger.info("Render to string from view_path=#{view_path} with options=#{view_options}")}
          file << ApplicationController.new.render_to_string(view_path, view_options)
        end if compile_path
      end

    private

      def corporate_location
        Location.corporate || Location.first
      end

      def compile_path
        File.join(@base_path.to_s, @slug, "index.html")
      end

      def view_path
        "area_pages/show"
      end

      def view_options
        LOGGERS.each {|logger| logger.debug("creating view_options hash")}
        LOGGERS.each {|logger| logger.debug("going to call LocationCollector.new with #{@params} and then .collect")}
        LOGGERS.each {|logger| logger.debug("setting web_template to: #{corporate_location.website.website_template.to_s}")}
        LOGGERS.each {|logger| logger.debug("setting area to: #{area.to_s}")}
        options = { layout: "web_template",
          locals: {
            locations: LocationCollector.new(@params).collect,
            web_template: corporate_location.website.website_template,
            area: area,
            params: @params,
            mode: "deployed",
            is_preview: false
          }
        }
        LOGGERS.each {|logger| logger.debug("the options are: #{options}")}
        options
      end

      def area
        areas = [@params[:neighborhood], @params[:city], @params[:state]]
        areas.reject(&:blank?).map(&:humanize).map(&:titleize).join(", ")
      end
    end
  end
end

