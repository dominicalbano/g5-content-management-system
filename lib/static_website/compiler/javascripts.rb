require "static_website/compiler/javascript"
require "static_website/compiler/javascript/compressor"

LOGGERS = [Rails.logger, Resque.logger]

module StaticWebsite
  module Compiler
    class Javascripts
      attr_reader :javascript_paths, :compile_path, :location_name, :preview,
        :js_paths, :include_paths

      def initialize(javascript_paths, compile_path, page_name, location_name="", preview=false)
        javascript_paths = Array(javascript_paths)
        LOGGERS.each{|logger| logger.debug("\n\nInitializing StaticWebsite::Compiler::Javascripts with javascript_paths: #{javascript_paths.join("\n\t").prepend("\n\t")},\n\n\tcompile_path: #{compile_path},\n\tlocation_name: #{location_name},\n\tpreview: #{preview}\n")} if javascript_paths
        @javascript_paths = javascript_paths.try(:compact).try(:uniq)
        @compile_path = compile_path
        @location_name = location_name
        @preview = preview
        @js_paths = []
        @include_paths = []
        @page_name = page_name
      end

      def compile
        @js_paths = []
        @include_paths = []
        uploaded_paths = []
        unless javascript_paths.empty?
          javascript_paths.each do |javascript_path|
            compile_javascript(javascript_path)
          end

          unless preview
            LOGGERS.each{|logger| logger.debug("About to call javascript_compressor.compile")}
            @js_paths = Array(javascript_compressor.compile) 
            LOGGERS.each{|logger| logger.debug("Done calling javascript_compressor.compile")}
            LOGGERS.each{|logger| logger.debug("Calling compile on javascript_uploader unless preview")}
            uploaded_paths = Javascript::Uploader.new(js_paths, location_name).upload
          end
          uploaded_paths 
        end
      end

      def compile_javascript(javascript_path)
        if javascript_path
          javascript = Javascript.new(javascript_path, compile_path)
          javascript.compile
          @js_paths << javascript.js_path
          @include_paths << javascript.include_path
        end
      end

      def javascript_compressor
        @javascript_compressor ||= Javascript::Compressor.new(js_paths, compressed_path)
      end

      def compressed_path
        @compressed_path ||= File.join(compile_path, "javascripts",
                                       "#{@page_name.parameterize}-#{Time.now.to_i}.min.js")
      end
    end
  end
end

