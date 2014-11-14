require "static_website/compiler/web_template"

module StaticWebsite
  module Compiler
    class WebTemplates
      attr_reader :web_template_models

      def initialize(web_template_models)
        @web_template_models = web_template_models
      end

      def compile
        web_template_models.each do |web_template_model|
          LOGGERS.each{|logger| logger.info("\n\n########################################### #{web_template_model.name.to_s} ######\n")}
          LOGGERS.each{|logger| logger.info("Starting compile_web_template for web_template: #{web_template_model.name.to_s}")}
          compile_web_template(web_template_model)
          LOGGERS.each{|logger| logger.info("\n\n############################################n\n")}
        end if web_template_models
      end

      def compile_web_template(web_template_model)
        WebTemplate.new(web_template_model).compile
      end
    end
  end
end
