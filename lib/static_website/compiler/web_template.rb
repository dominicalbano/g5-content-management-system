require "static_website/compiler/view"

module StaticWebsite
  module Compiler
    class WebTemplate
      attr_reader :web_template, :compile_path

      def initialize(web_template)
        @web_template = web_template
        @compile_path = @web_template.compile_path if @web_template
      end

      def compile
        LOGGERS.each {|logger| logger.debug("3333333333333333333333333333333333333333333")}
        LOGGERS.each {|logger| logger.debug("WebTemplate.compile - about to call view.compile with options\n #{view_options}")}
        view.compile
      end

      def view
        @view ||= View.new(view_path, view_options, compile_path)
      end

      def view_path
        "web_templates/show"
      end

      def view_options
        { layout: "web_template",
          locals: {
            location: web_template.try(:owner),
            website: web_template.try(:website),
            web_template: web_template,
            mode: "deployed"
          }
        }
      end
    end
  end
end

