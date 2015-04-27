module StaticWebsite
  module Compiler
    module MultiDomain
      class Sitemap

        def initialize(website, area_pages=[])
          @website_compile_path = website.compile_path
          @web_home_template = website.web_home_template
          @web_page_templates = website.web_page_templates.enabled
          @area_pages = area_pages
        end

        def compile
          compile_directory.compile
          render_to_file
        end

        private

        def compile_path
          File.join(@website_compile_path.to_s, "sitemap.xml")
        end


        def compile_directory
          @compile_directory ||= CompileDirectory.new(compile_path, false)
        end

        def render_sitemap
          urls = []
          urls << web_home_template_xml
          @web_page_templates.each do |template|
            urls << web_page_template_xml(template)
          end
          @area_pages.each do |area_page_path|
            urls << area_page_xml(area_page_path)
          end

          sitemap_contents = ["<?xml version='1.0' encoding='UTF-8'?>",
                              "<urlset xmlns='http://www.sitemaps.org/schemas/sitemap/0.9'>",
                              urls,
                              "</urlset>"]

          return sitemap_contents.flatten.join("\n")
        end

        def render_to_file
          open(compile_path, "wb") do |file|
            file << render_sitemap
          end if compile_path
        end

        def web_home_template_xml
          <<-end.strip_heredoc
          <url>
            <loc>#{@web_home_template.owner_domain}</loc>
            <lastmod>#{@web_home_template.last_mod}</lastmod>
            <changefreq>weekly</changefreq>
            <priority>0.9</priority>
          </url>
          end
        end

        def web_page_template_xml(template)
          <<-end.strip_heredoc
          <url>
            <loc>#{File.join(@web_home_template.owner_domain, @web_home_template.client.vertical_slug, @web_home_template.owner.state_slug, @web_home_template.owner.city_slug)}/#{template.slug}</loc>
            <lastmod>#{template.last_mod}</lastmod>
            <changefreq>weekly</changefreq>
            <priority>0.7</priority>
          </url>
          end
        end

        def area_page_xml(area_page_path)
          <<-end.strip_heredoc
          <url>
            <loc>#{File.join(@web_home_template.owner_domain, area_page_path)}</loc>
            <changefreq>monthly</changefreq>
            <priority>0.6</priority>
          </url>
          end
        end

      end
    end
  end
end

