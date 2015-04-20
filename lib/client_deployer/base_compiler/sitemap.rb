require "static_website/compiler/sitemap_compiler"

module ClientDeployer
  module BaseCompiler
    class Sitemap
      def initialize(client)
        @client = client
        @urls = []
      end

      def compile
        compile_directory.compile
        render_to_file
      end

      private

      def compile_path
        File.join(@client.website.decorate.compile_path, "sitemap.xml")
      end

      def compile_directory
        @compile_directory ||= StaticWebsite::Compiler::SitemapCompiler.new(compile_path, false)
      end

      def render_sitemap
        Website.location_websites.each { |website| compile_directory.process_website(website.decorate) }
        compile_directory.sitemap_contents
      end

      def render_to_file
        open(compile_path, "wb") { |file| file << render_sitemap } if compile_path
      end
    end
  end
end

