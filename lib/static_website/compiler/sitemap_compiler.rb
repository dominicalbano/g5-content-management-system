module StaticWebsite
  module Compiler
    class SitemapCompiler < StaticWebsite::Compiler::CompileDirectory
      def initialize(path, directory=true, websites=[], area_pages=[])
        super(path, directory)
        @urls = []
        @websites = websites
        @area_pages = area_pages
      end

      def sitemap_contents
        [ "<?xml version='1.0' encoding='UTF-8'?>",
          "<urlset xmlns='http://www.sitemaps.org/schemas/sitemap/0.9'>",
          @urls.flatten,
          "</urlset>" ].flatten.join("\n")
      end

      def sitemap_xml(url, last_mod, changefreq='weekly', priority=0.7)
        <<-end.strip_heredoc
            <url>
              <loc>#{url}</loc>
              <lastmod>#{last_mod}</lastmod>
              <changefreq>#{changefreq}</changefreq>
              <priority>#{priority}</priority>
            </url>
          end
      end

      def compile_and_render_to_file
        compile
        render_to_file
      end

      def render_to_file
        open(File.join(@path, 'sitemap.xml'), "wb") { |file| file << render_sitemap } if @path
      end

      def render_sitemap
        @websites.each { |website| process_website(website.decorate) }
        sitemap_contents
      end

      def process_website(website)
        web_home = website.web_home_template
        web_pages = website.web_page_templates

        if web_home
          process_web_home_template(web_home) if web_home.enabled
          web_pages.each do |template|
            process_web_template(web_home, template)
          end
          @area_pages.each do |area_page_path|
            process_area_page(area_page_path)
          end
        end
      end

      def process_web_home_template(web_home_template)
        @urls << sitemap_xml(web_home_template.owner.domain, web_home_template.last_mod, 'weekly', 0.9)
      end

      def process_web_template(web_home_template, template)
        if web_home_template && template.enabled
          url = web_template_url(web_home_template, template)
          @urls << sitemap_xml(url, template.last_mod)
        end
      end

      def process_area_page(area_page_path)
        @urls << sitemap_xml(File.join(Client.first.domain, area_page_path), '', 'monthly', 0.6)
      end

      def web_template_url(web_home_template, template)
        owner = web_home_template.owner
        path = File.join(owner.domain, web_home_template.client.vertical_slug, owner.state_slug, owner.city_slug, web_home_template.website.slug)
        "#{path}/#{template.slug}"
      end
    end
  end
end

