module StaticWebsite
  module Compiler
    class AreaPage
      def initialize(base_path, slug, params)
        @base_path = base_path
        @slug = slug
        @params = params
      end

      def compile
        LOGGERS.each {|logger| logger.info("calling compile_directory.compile with compile_path #{compile_path}")}
        compile_directory.compile
        LOGGERS.each {|logger| logger.info("calling render_to_file")}
        render_to_file
      end

      def compile_directory
        @compile_directory ||= CompileDirectory.new(compile_path, false)
      end

      def render_to_file
        open(compile_path, "wb") do |file|
          file << ApplicationController.new.render_to_string(view_path, view_options)
        end if compile_path
      end

    private

      def compile_path
        File.join(@base_path.to_s, @slug, "index.html")
      end

      def view_path
        "area_pages/show"
      end

      def view_options
        { layout: "web_template",
          locals: {
            locations: LocationCollector.new(@params).collect,
            web_template: Location.corporate.website.website_template,
            area: area,
            params: @params,
            mode: "deployed"
          }
        }
      end

      def area
        areas = [@params[:neighborhood], @params[:city], @params[:state]]
        areas.reject(&:blank?).map(&:humanize).map(&:titleize).join(", ")
      end
    end
  end
end
