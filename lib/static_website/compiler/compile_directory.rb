module StaticWebsite
  module Compiler
    class CompileDirectory
      attr_reader :path

      def initialize(path, directory=true)
        LOGGERS.each{|logger| logger.debug("Initializing StaticWebsite::Compiler::CompileDirectory with path: #{path}, directory: #{directory}")}
        @path = directory ? path : directory_path(path)
      end

      def directory_path(file_path)
        File.join(file_path.split("/")[0..-2]) if file_path
      end

      def compile
        if @path && !Dir.exists?(@path)
          LOGGERS.each { |logger| logger.info("#{self.class.to_s}##{__method__.to_s} Making directory: #{@path}") }
          FileUtils.mkdir_p(@path)
        end
      end

      def clean_up
        if @path && Dir.exists?(@path)
          LOGGERS.each{|logger| logger.info("#{self.class.to_s}##{__method__.to_s} Removing directory: #{@path}")}
          FileUtils.rm_rf(@path)
        end
      end
    end
  end
end

