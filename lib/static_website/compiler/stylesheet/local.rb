require "static_website/compiler/view"

module StaticWebsite
  module Compiler
    class Stylesheet
      class Local
        attr_reader :colors, :fonts, :compile_paths

        def initialize(colors, fonts, compile_path)
          @colors = colors || {}
          @fonts = fonts || {}
          @compile_paths = [
            File.join(compile_path, "stylesheets", "colors.css"),
            File.join(compile_path, "stylesheets", "fonts.css")
          ] if compile_path
        end

        def compile
          view.compile
        end

        def view
          @view ||= View.new(view_path, view_options, compile_path)
        end

        def view_path
          "web_templates/stylesheets"
        end

        def options
          { syntax: :scss,
            load_paths: [compile_directory.path] }
        end

        private

        def render_to_file
          compile_paths.each do |cpath|
            open(cpath, "wb") do |file|
              file << Sass::Engine.new(open(stylesheet_path).read, options).render
            end
          end if compile_paths
        end
    end
  end
end
