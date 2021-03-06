module StaticWebsite
  module Compiler
    class CompileDirectory
      attr_reader :path

      def initialize(path, directory=true)
        LOGGERS.each{|logger| logger.debug("Initializing StaticWebsite::Compiler::CompileDirectory with path:\n #{path}, directory: #{directory}")}
        @path = directory ? path : directory_path(path)
      end

      def directory_path(file_path)
        File.join(file_path.split("/")[0..-2]) if file_path
      end

      def compile
        LOGGERS.each{|logger| logger.debug("Making directory: #{@path}")}
        FileUtils.mkdir_p(@path) if @path && !Dir.exists?(@path)
      end

      def clean_up
        LOGGERS.each{|logger| logger.debug("Removing directory: #{@path}")}
        FileUtils.rm_rf(@path) if @path && Dir.exists?(@path)
      end
    end
  end
end

