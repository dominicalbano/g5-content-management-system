require "static_website/compiler/compile_directory"

module StaticWebsite
  module Compiler
    class Compressor
      attr_reader :file_paths, :compile_path, :compressor

      def initialize(file_paths, compile_path)
        write_to_loggers("\n\nInitializing StaticWebsite::Compiler::#{klass}::Compressor with file_paths:#{file_paths.join("\n\t").prepend("\n\t")},\n\n\tcompile_path: #{compile_path}") if file_paths
        @file_paths = file_paths
        @compile_path = compile_path
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
        write_to_loggers("Compressing #{klass} on compile_path:\n#{@compile_path}")
        open(@compile_path, "w") do |file|
          write_to_loggers("calling compressor.compile(concatenate)")
          write_compressed_to_file(file)
        end if @compile_path
        @compile_path
      end

      def concatenate
        result = @file_paths.map do |file_path|
          write_to_loggers("getting file_path:\n#{file_path.to_s}\n for concatenation")
          if File.exists?(file_path)
            file = open(file_path).read
            File.delete(file_path)
            file
          end
        end.join("\n")
        result
      end

      protected

      def write_compressed_to_file(file)
        file.write compressor.compile(concatenate, compressor_options) if file
      end

      def klass
        raise NotImplementedError
      end

      def compressor
        raise NotImplementedError
      end

      def compressor_options
        {}
      end
    end
  end
end
