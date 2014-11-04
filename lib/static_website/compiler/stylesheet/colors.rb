require "static_website/compiler/view"

module StaticWebsite
  module Compiler
    class Stylesheet
      class Colors
        attr_reader :colors, :compile_path

        def initialize(colors, compile_path)
          @colors = colors || {}
          @compile_path = File.join(compile_path, "stylesheets", "colors.scss") if compile_path
        end

        def compile
          view.compile
        end

        def view
          @view ||= View.new(view_path, view_options, compile_path)
        end

        def view_path
          "web_templates/stylesheets/colors"
        end

        def view_options
          { formats: [:scss],
            layout:  false,
            locals:  {
              primary_color: colors[:primary_color],
              secondary_color: colors[:secondary_color],
              tertiary_color: colors[:tertiary_color]
            }
          }
        end
      end
    end
  end
end
