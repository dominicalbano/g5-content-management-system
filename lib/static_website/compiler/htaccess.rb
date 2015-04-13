module StaticWebsite
  module Compiler
    class HTAccess

      def initialize(website)
        @website = website
        @website_compile_path = website.compile_path
        @web_home_template = website.web_home_template
        @web_page_templates = website.web_page_templates
      end

      def compile_path
        File.join(@website_compile_path.to_s, ".htaccess")
      end

      def compile
        compile_directory.compile
        render_to_file
      end

      def compile_directory
        @compile_directory ||= CompileDirectory.new(compile_path, false)
      end

      def render_htaccess
        # array of redirect patterns after being formatted for htaccess
        redirect_rules = []
        templates = (@web_page_templates + [@web_home_template]).compact

        templates.each do |template|
          if template.redirect_patterns
            template.redirect_patterns.split.each do |pattern|
              redirect_rules << "\tRewriteRule ^#{pattern} #{template.htaccess_substitution} [R=301,L]"
            end
          end
        end

        if @web_home_template
          empty_folders = ["\tRewriteRule ^#{File.join(@web_home_template.client.vertical_slug)}/?$ #{@web_home_template.htaccess_substitution} [R=301,L]",
                           "\tRewriteRule ^#{File.join(@web_home_template.client.vertical_slug, @web_home_template.owner.state_slug)}/?$ #{@web_home_template.htaccess_substitution} [R=301,L]",
                           "\tRewriteRule ^#{File.join(@web_home_template.client.vertical_slug, @web_home_template.owner.state_slug, @web_home_template.owner.city_slug)}/?$ #{@web_home_template.htaccess_substitution} [R=301,L]"]
        else
          empty_folders = []
        end

        htaccess_contents = ["DirectoryIndex index.html",
                             "<IfModule mod_rewrite.c>",
                             "\tRewriteEngine On",
                             empty_folders,
                             redirect_rules]

        if @website.owner.try(:secure_domain)
          htaccess_contents << ["\tRewriteCond %{HTTPS} !=on",
                                "\tRewriteCond %{HTTP:X-Forwarded-Proto} !https",
                                "\tRewriteRule ^ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]"]
        end

        htaccess_contents << ["\tRewriteCond %{REQUEST_FILENAME} !-d",
                              "\tRewriteCond %{REQUEST_FILENAME} !-f",
                              "\tRewriteRule ^(.*)/$ /$1 [L,R=301]",
                              "</IfModule>"]

        return htaccess_contents.flatten.join("\n")
      end

      private

      def render_to_file
        open(compile_path, "wb") do |file|
          file << render_htaccess
        end if compile_path
      end
    end
  end
end
