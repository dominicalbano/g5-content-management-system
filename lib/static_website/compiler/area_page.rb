module StaticWebsite
  module Compiler
    class AreaPage
      def initialize(base_path, slug, params)
        @base_path = base_path
        @slug = slug
        @params = params
      end

      def compile
        write_to_loggers("calling compile_directory.compile with compile_path #{compile_path}")
        compile_directory.compile
        write_to_loggers("calling render_to_file")
        render_to_file
        compile_path.split(@base_path)[1]
      end

      def compile_directory
        @compile_directory ||= CompileDirectory.new(compile_path, false)
      end

      def render_to_file
        write_to_loggers("opening compile_path #{compile_path}")
        open(compile_path, "wb") do |file|
          write_to_loggers("about to try to render to string from #{view_path} with options")
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
        write_to_loggers("creating view_options hash")
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
        write_to_loggers("the options are: #{options}")
        options
      end

      def area
        area_params.map { |a| a.humanize.titleize }.join(", ")
      end

      def area_params
        [@params[:neighborhood], @params[:city], @params[:state]].reject(&:blank?)
      end
    end
  end
end

