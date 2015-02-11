require "static_website/compiler/compile_directory"
require "open-uri"

module StaticWebsite
  module Compiler
    class RemoteFile
      attr_reader :remote_path, :compile_path

      def initialize(remote_path, compile_path)
        LOGGERS.each{|logger| logger.debug("\n\nInitializing StaticWebsite::Compiler::RemoteFile with remote_path: #{remote_path},\n\n\tcompile_path: #{compile_path}")}
        @remote_path = remote_path
        @compile_path = compile_path
      end

      def compile
        LOGGERS.each{|logger| logger.debug("about to call compile_directory.compile")}
        compile_directory.compile
        LOGGERS.each{|logger| logger.debug("done calling compile_directory.compile")}
        LOGGERS.each{|logger| logger.debug("about to write_to_file")}
        result = write_to_file
        LOGGERS.each{|logger| logger.debug("done write_to_file")}
        result
      end

      def compile_directory
        @compile_directory ||= CompileDirectory.new(compile_path, false)
      end

      private

      def write_to_file
        LOGGERS.each{|logger| logger.debug("opening #{compile_path}")}
        open(compile_path, "wb") do |file|
          LOGGERS.each{|logger| logger.debug("shoveling contents of #{remote_path} into #{compile_path}")}
          file << open(remote_path).read
        end if compile_path
      rescue OpenURI::HTTPError => e
        if e.message.include?("404")
          Rails.logger.warn e.message
        else
          raise e
        end
      end
    end
  end
end

