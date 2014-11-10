require "static_website/compiler/javascript"
require "static_website/compiler/javascript/compressor"

module StaticWebsite
  module Compiler
    class Javascripts
      attr_reader :javascript_paths, :compile_path, :location_name, :preview,
        :js_paths, :include_paths

      def initialize(javascript_paths, compile_path, location_name="", preview=false)
        Rails.logger.info("\n$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$\n")
        Rails.logger.info("Initializing StaticWebsite::Compiler::Javascript with javascript_paths: #{javascript_paths}, compile_path: #{compile_path}, location_name: #{location_name}, preview: #{preview}")
        @javascript_paths = javascript_paths.try(:compact).try(:uniq)
        @compile_path = compile_path
        @location_name = location_name
        @preview = preview
        @js_paths = []
        @include_paths = []
      end

      def compile
        @js_paths = []
        @include_paths = []
        if javascript_paths
          javascript_paths.each do |javascript_path|
            compile_javascript(javascript_path)
          end

          # javascript_compressor.compile unless preview
          Rails.logger.info(("Calling compile on javascript_uploader unless preview")
          javascript_uploader.compile unless preview
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
        @compressed_path ||= File.join(compile_path, "javascripts", "application.min.js")
      end

      def javascript_uploader
        @javascript_uploader ||= Javascript::Uploader.new(js_paths, location_name)
      end

      def uploaded_paths
        @uploaded_path ||= javascript_uploader.uploaded_paths
      end
    end
  end
end
