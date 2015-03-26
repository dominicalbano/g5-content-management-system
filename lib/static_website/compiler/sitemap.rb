module StaticWebsite
  module Compiler
    class Sitemap

      def initialize(website)
        @website_compile_path = website.compile_path
        @web_home_template = website.web_home_template
        @web_page_templates = website.web_page_templates
      end

      def compile_path
        File.join(@website_compile_path.to_s, "sitemap.xml")
      end

      def compile
        compile_directory.find_or_make_dir
        render_to_file
      end

      def compile_directory
        @compile_directory ||= CompileDirectory.new(compile_path, false)
      end

      def render_sitemap
        urls = []

        # Web Home Template
        if @web_home_template && @web_home_template.enabled
          web_home_template = <<-end.strip_heredoc
            <url>
              <loc>#{@web_home_template.owner_domain}</loc>
              <lastmod>#{@web_home_template.last_mod}</lastmod>
              <changefreq>weekly</changefreq>
              <priority>0.9</priority>
            </url>
          end
          urls << web_home_template
        end

        # Web Page Templates
        @web_page_templates.each do |template|
          if @web_home_template && template.enabled
            web_page_template = <<-end.strip_heredoc
              <url>
                <loc>#{File.join(@web_home_template.owner_domain, @web_home_template.client.vertical_slug, @web_home_template.owner.state_slug, @web_home_template.owner.city_slug)}/#{template.slug}</loc>
                <lastmod>#{template.last_mod}</lastmod>
                <changefreq>weekly</changefreq>
                <priority>0.7</priority>
              </url>
            end
            urls << web_page_template
          end
        end

        sitemap_contents = ["<?xml version='1.0' encoding='UTF-8'?>",
                            "<urlset xmlns='http://www.sitemaps.org/schemas/sitemap/0.9'>",
                            urls,
                            "</urlset>"]

        return sitemap_contents.flatten.join("\n")
      end

      private

      def render_to_file
        open(compile_path, "wb") do |file|
          file << render_sitemap
        end if compile_path
      end
    end
  end
end
