module ClientDeployer
  module WebsiteCompiler
    class Website < StaticWebsite::Compiler::Website
      def compile
        LOGGERS.each {|logger| logger.debug("2222222222222222222222222222222222222222222")}
        LOGGERS.each {|logger| logger.debug("calling compile_directory.find_or_make_dir")}
        compile_directory.find_or_make_dir
        LOGGERS.each {|logger| logger.debug("2222222222222222222222222222222222222222222")}
        LOGGERS.each {|logger| logger.debug("calling stylesheets.compile")}
        stylesheets.compile
        LOGGERS.each {|logger| logger.debug("2222222222222222222222222222222222222222222")}
        LOGGERS.each {|logger| logger.debug("calling web_home_template.compile")}
        web_home_template.compile
        LOGGERS.each {|logger| logger.debug("2222222222222222222222222222222222222222222")}
        LOGGERS.each {|logger| logger.debug("calling web_page_templates.compile")}
        web_page_templates.compile
      end
    end
  end
end
