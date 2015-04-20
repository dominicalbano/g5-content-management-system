require "static_website/compiler/compile_directory"

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
        StaticWebsite::Compiler::CompileDirectory.new(compile_path, false)
      end

      def render_sitemap
        Website.location_websites.each { |website| process_website(website.decorate) }

        sitemap_contents = ["<?xml version='1.0' encoding='UTF-8'?>",
                            "<urlset xmlns='http://www.sitemaps.org/schemas/sitemap/0.9'>",
                            @urls.flatten,
                            "</urlset>"]

        sitemap_contents.flatten.join("\n")
      end

      def process_website(website)
        web_home_template = website.web_home_template
        web_page_templates = website.web_page_templates

        if web_home_template && web_home_template.enabled
          process_web_home_template(web_home_template)
        end

        web_page_templates.each do |template|
          process_web_template(web_home_template, template)
        end
      end

      def process_web_home_template(web_home_template)
        web_home_template = <<-end.strip_heredoc
          <url>
            <loc>#{web_home_template.owner.domain}</loc>
            <lastmod>#{web_home_template.last_mod}</lastmod>
            <changefreq>weekly</changefreq>
            <priority>0.9</priority>
          </url>
        end

        @urls << web_home_template
      end

      def process_web_template(web_home_template, template)
        if web_home_template && template.enabled
          web_page_template = <<-end.strip_heredoc
            <url>
              <loc>#{File.join(web_home_template.owner.domain, @client.vertical_slug, web_home_template.owner.state_slug, web_home_template.owner.city_slug, web_home_template.website.slug)}/#{template.slug}</loc>
              <lastmod>#{template.last_mod}</lastmod>
              <changefreq>weekly</changefreq>
              <priority>0.7</priority>
            </url>
          end

          @urls << web_page_template
        end
      end

      def render_to_file
        open(compile_path, "wb") do |file|
          file << render_sitemap
        end if compile_path
      end
    end
  end
end

