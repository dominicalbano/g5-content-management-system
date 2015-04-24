require "static_website/compiler/compile_directory"
require "uglifier"

module StaticWebsite
  module Compiler
    class Javascript
      class Compressor < StaticWebsite::Compiler::Compressor
        def initialize(file_paths, compile_path)
          super(file_paths, compile_path)
        end

        protected

        def write_compressed_to_file(file)
          file.write compressor.compile(concatenate) if file
        end

        def klass
          Javascript
        end

        def compressor
          @compressor ||= Uglifier.new(comments: :none)
        end
      end
    end
  end
end
