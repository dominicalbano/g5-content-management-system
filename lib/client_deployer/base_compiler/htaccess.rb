require "static_website/compiler/compile_directory"

module ClientDeployer
  module BaseCompiler
    class HTAccess
      def initialize(client)
        @client = client
        @redirect_rules = []
        @empty_folders  = []
      end

      def compile
        compile_directory.compile
        render_to_file
      end

    private

      def compile_directory
        StaticWebsite::Compiler::CompileDirectory.new(compile_path, false)
      end

      def compile_path
        File.join(@client.website.decorate.compile_path, ".htaccess")
      end

      def render_htaccess
        Website.location_websites.each { |website| process_website(website.decorate) }

        htaccess_contents = ["DirectoryIndex index.html",
                             "<IfModule mod_rewrite.c>",
                             "\tRewriteEngine On",
                             @empty_folders.flatten,
                             @redirect_rules.flatten,
                             "\tRewriteRule ^(.*)/$ /$1 [L,R=301]",
                             "\tRewriteCond %{REQUEST_FILENAME} !-d",
                             "\tRewriteCond %{REQUEST_FILENAME} !-f",
                             "</IfModule>",
                             "SetEnvIfNoCase Referer semalt.com spammer=yes",
                             "Order allow,deny",
                             "Allow from all",
                             "Deny from env=spammer"]
        htaccess_contents.flatten.join("\n")
      end

      def process_website(website)
        web_home_template = website.web_home_template
        templates = (website.web_page_templates + [web_home_template]).compact
        templates.each { |template| process_template(template) }

        @empty_folders << ["\tRewriteRule ^#{File.join(@client.vertical_slug)}/?$ #{web_home_template.htaccess_substitution} [R=301,L]",
                           "\tRewriteRule ^#{File.join(@client.vertical_slug, web_home_template.owner.state_slug)}/?$ #{web_home_template.htaccess_substitution} [R=301,L]",
                           "\tRewriteRule ^#{File.join(@client.vertical_slug, web_home_template.owner.state_slug, web_home_template.owner.city_slug)}/?$ #{web_home_template.htaccess_substitution} [R=301,L]"]
      end

      def process_template(template)
        if template.redirect_patterns
          template.redirect_patterns.split.each do |pattern|
            @redirect_rules << "\tRewriteRule ^#{pattern} #{template.htaccess_substitution} [R=301,L]"
          end
        end
      end

      def render_to_file
        open(compile_path, "wb") do |file|
          file << render_htaccess
        end if compile_path
      end
    end
  end
end
