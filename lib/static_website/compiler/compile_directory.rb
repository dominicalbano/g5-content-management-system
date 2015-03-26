module StaticWebsite
  module Compiler
    class CompileDirectory
      attr_reader :path

      def initialize(path, directory=true)
        @path = directory ? path : directory_path(path)
      end

      def directory_path(file_path)
        File.join(file_path.split("/")[0..-2]) if file_path
      end

      def find_or_make_dir
        FileUtils.mkpath(@path) if @path && !Dir.exists?(@path)
      end

      def clean_up
        FileUtils.rm_rf(@path) if @path && Dir.exists?(@path)
      end
    end
  end
end

