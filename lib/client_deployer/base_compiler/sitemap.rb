require "static_website/compiler/sitemap_compiler"

module ClientDeployer
  module BaseCompiler
    class Sitemap
      def initialize(client, area_pages=[])
        @client = client
        @compile_directory = StaticWebsite::Compiler::SitemapCompiler.new(compile_path, false, Website.location_websites, area_pages)
      end

      def compile
        @compile_directory.compile_and_render_to_file
      end

      private

      def compile_path
        File.join(@client.website.decorate.compile_path, "sitemap.xml")
      end
    end
  end
end

