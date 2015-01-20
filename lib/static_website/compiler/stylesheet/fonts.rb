require "static_website/compiler/view"

module StaticWebsite
  module Compiler
    class Stylesheet
      class Fonts
        attr_reader :fonts, :compile_path

        def initialize(fonts, compile_path)
          @fonts = fonts || {}
          @compile_path = File.join(compile_path, "stylesheets", "fonts.scss") if compile_path
        end

        def compile
          view.compile
        end

        def view
          @view ||= View.new(view_path, view_options, compile_path)
        end

        def view_path
          "web_templates/stylesheets/fonts"
        end

        def view_options
          { formats: [:scss],
            layout:  false,
            locals:  {
              primary_font: fonts[:primary_font],
              secondary_font: fonts[:secondary_font]
            }
          }
        end
      end
    end
  end
end
