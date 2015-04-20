module StaticWebsite
  module Compiler
    class Sitemap

      def initialize(website)
        @website = website
      end

      def compile
        compile_directory.compile
        render_to_file
      end

      private

      def compile_path
        File.join(@website.compile_path.to_s, "sitemap.xml")
      end

      def compile_directory
        @compile_directory ||= SitemapCompiler.new(compile_path, false)
      end

      def render_sitemap
        compile_directory.process_website(@website)
        compile_directory.sitemap_contents
      end

      def render_to_file
        open(compile_path, "wb") { |file| file << render_sitemap } if compile_path
      end
    end
  end
end
