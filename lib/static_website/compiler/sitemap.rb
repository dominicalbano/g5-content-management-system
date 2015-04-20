module StaticWebsite
  module Compiler
    class Sitemap

      def initialize(website)
        @website = website
        @compile_directory = SitemapCompiler.new(compile_path, false, [@website])
      end

      def compile
        @compile_directory.compile_and_render_to_file
      end

      private

      def compile_path
        File.join(@website.compile_path.to_s, "sitemap.xml")
      end
    end
  end
end
