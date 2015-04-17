module StaticWebsite
  module Compiler
    class CompileDirectory
      attr_reader :path

      def initialize(path, directory=true)
        write_to_loggers("Initializing StaticWebsite::Compiler::CompileDirectory with path:\n #{path}, directory: #{directory}")
        @path = directory ? path : directory_path(path)
      end

      def directory_path(file_path)
        File.join(file_path.split("/")[0..-2]) if file_path
      end

      def compile
        write_to_loggers("Making directory: #{@path}")
        FileUtils.mkdir_p(@path) if @path && !Dir.exists?(@path)
      end

      def clean_up
        write_to_loggers("Removing directory: #{@path}")
        FileUtils.rm_rf(@path) if @path && Dir.exists?(@path)
      end
    end
  end
end

