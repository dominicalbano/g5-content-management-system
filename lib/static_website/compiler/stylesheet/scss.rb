require "static_website/compiler/compile_directory"

module StaticWebsite
  module Compiler
    class Stylesheet
      class Scss
        attr_reader :stylesheet_path, :compile_path

        def initialize(stylesheet_path, compile_path)
          @stylesheet_path = stylesheet_path
          @compile_path = compile_path
        end

        def compile
          compile_directory.compile
          render_to_file
        end

        def compile_directory
          @compile_directory ||= CompileDirectory.new(compile_path, false)
        end

        def options
          { syntax: :scss,
            load_paths: [compile_directory.path, local_stylesheet_path] }
        end

        def local_stylesheet_path
          File.join(Rails.root, "app", "views", "web_templates", "stylesheets")
        end

        private

        def render_to_file
          open(compile_path, "wb") do |file|
            write_to_loggers("\n$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$\n")
            write_to_loggers("Compiling sass file from path: \n#{stylesheet_path}\n with options: #{options}")
            css = Sass.compile(open(stylesheet_path).read, options)
            file << css
          end if compile_path
        end
      end
    end
  end
end
