require "sass"

module StaticWebsite
  module Compiler
    class Stylesheet
      class Compressor < StaticWebsite::Compiler::Compressor
        def initialize(file_paths, compile_path)
          super(file_paths, compile_path)
        end

        protected

        def klass
          Stylesheet
        end

        def compressor
          Sass
        end

        def compressor_options
          { style: :compressed }
        end
      end
    end
  end
end
