require "static_website/compiler/compile_directory"
require "uglifier"

module StaticWebsite
  module Compiler
    class Javascript
      class Compressor
        attr_reader :file_paths, :compile_path, :compressor

        def initialize(file_paths, compile_path)
          @file_paths = file_paths
          @compile_path = compile_path
          @compressor ||= Uglifier.new
        end

        def compile
          File.delete(compile_path) if File.exists?(compile_path)
          compile_directory.compile
          compress
        end

        def compile_directory
          @compile_directory ||= CompileDirectory.new(compile_path, false)
        end

        def compress
          open(compile_path, "w") do |file|
            file.write compressor.compile(concatenate)
          end if compile_path
        end

        def concatenate
          file_paths.map do |file_path|
            if File.exists?(file_path)
              js = compressor.compile(open(file_path).read)
              File.delete(file_path)
              js
            end
          end.join("")
        end
      end
    end
  end
end
