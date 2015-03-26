require "static_website/compiler/compile_directory"
require "sass"

module StaticWebsite
  module Compiler
    class Stylesheet
      class Compressor
        attr_reader :file_paths, :compile_path, :compressor

        def initialize(file_paths, compile_path)
          @file_paths = file_paths
          @compile_path = compile_path
          @compressor ||= Sass
        end

        def compile
          File.delete(compile_path) if File.exists?(compile_path)
          compile_directory.find_or_make_dir
          compress
        end

        def compile_directory
          @compile_directory ||= CompileDirectory.new(compile_path, false)
        end

        def compress
          open(compile_path, "w") do |file|
            file.write compressor.compile(concatenate, compressor_options)
          end if compile_path
        end

        def concatenate
          file_paths.map do |file_path|
            if File.exists?(file_path)
              css = open(file_path).read
              File.delete(file_path)
              css
            end
          end.join("")
        end

        def compressor_options
          { style: :compressed }
        end
      end
    end
  end
end
