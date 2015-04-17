require "static_website/compiler/compile_directory"
require "open-uri"

module StaticWebsite
  module Compiler
    class RemoteFile
      attr_reader :remote_path, :compile_path

      def initialize(remote_path, compile_path)
        write_to_loggers("\n\nInitializing StaticWebsite::Compiler::RemoteFile with remote_path: #{remote_path},\n\n\tcompile_path: #{compile_path}")
        @remote_path = remote_path
        @compile_path = compile_path
      end

      def compile
        write_to_loggers("about to call compile_directory.compile")
        compile_directory.compile
        write_to_loggers("done calling compile_directory.compile")
        write_to_loggers("about to write_to_file")
        result = write_to_file
        write_to_loggers("done write_to_file")
        result
      end

      def compile_directory
        @compile_directory ||= CompileDirectory.new(compile_path, false)
      end

      private

      def write_to_file
        write_to_loggers("opening #{compile_path}")
        open(compile_path, "wb") do |file|
          write_to_loggers("shoveling contents of #{remote_path} into #{compile_path}")
          file << read_remote(remote_path)
        end if compile_path
      rescue OpenURI::HTTPError => e
        if e.message.include?("404")
          Rails.logger.warn e.message
        else
          raise e
        end
      end

      def read_remote(remote_path)
        retries = [3, 5, 10]
        begin
          open(remote_path).read
        rescue OpenURI::HTTPError
          if delay = retries.shift
            sleep delay
            retry
          else
            raise
          end
        end
      end

    end
  end
end
