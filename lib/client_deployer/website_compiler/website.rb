module ClientDeployer
  module WebsiteCompiler
    class Website < StaticWebsite::Compiler::Website
      def compile
        compile_directory.compile
        stylesheets.compile
        web_home_template.compile
        web_page_templates.compile
      end
    end
  end
end
