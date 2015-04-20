module StaticWebsite
  module Compiler
    class SitemapCompiler < StaticWebsite::Compiler::CompileDirectory
      def initialize(path, directory=true)
        super(path, directory)
        @urls = []
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

      def process_website(website)
        web_home = website.web_home_template
        web_pages = website.web_page_templates

        if web_home
          process_web_home_template(web_home) if web_home.enabled
          web_pages.each do |template|
            process_web_template(web_home, template)
          end
        end
      end

      def process_web_home_template(web_home_template)
        @urls << compile_directory.sitemap_contents(web_home_template.owner.domain, web_home_template.last_mod, 'weekly', 0.9)
      end

      def process_web_template(web_home_template, template)
        if web_home_template && template.enabled
          url = web_template_url(web_home_template, template)
          web_page_template = compile_directory.sitemap_contents(url, template.last_mod)
          @urls << web_page_template
        end
      end

      def web_template_url(web_home_template, template)
        owner = web_home_template.owner
        path = File.join(owner.domain, @client.vertical_slug, owner.state_slug, owner.city_slug, web_home_template.website.slug)
        "#{path}/#{template.slug}"
      end
    end
  end
end

