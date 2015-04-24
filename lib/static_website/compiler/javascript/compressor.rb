require "static_website/compiler/compile_directory"
require "uglifier"

module StaticWebsite
  module Compiler
    class Javascript
      class Compressor
        attr_reader :file_paths, :compile_path, :compressor

        def initialize(file_paths, compile_path)
          write_to_loggers("\n\nInitializing StaticWebsite::Compiler::Javascript::Compressor with file_paths:#{file_paths.join("\n\t").prepend("\n\t")},\n\n\tcompile_path: #{compile_path}") if file_paths

          @file_paths = file_paths
          @compile_path = compile_path
          @compressor ||= Uglifier.new(comments: :none)
        end

        def compile
          File.delete(@compile_path) if File.exists?(@compile_path)
          compile_directory.compile
          compress
        end

        def compile_directory
          @compile_directory ||= CompileDirectory.new(@compile_path, false)
        end

        def compress
          write_to_loggers("compile_path:\n#{compile_path}")
          compressed = open(@compile_path, "w") do |file|
            write_to_loggers("calling compressor.compile(concatenate)")
            file.write @compressor.compile(concatenate)
          end if @compile_path
          compile_path
        end

        def concatenate
          result = @file_paths.map do |file_path|
            write_to_loggers("getting file_path:\n#{file_path.to_s}\n for concatenation")
            if File.exists?(file_path)
              js = open(file_path).read
              File.delete(file_path)
              js
            end
          end.join("\n")
          result
        end

      end
    end
  end
end
