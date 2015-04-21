require "static_website/compiler/javascript"
require "static_website/compiler/javascript/compressor"

module StaticWebsite
  module Compiler
    class Javascripts < StaticWebsite::Compiler::Assets

      def initialize(javascript_paths, compile_path, page_name, location_name="", preview=false)
        super(javascript_paths, compile_path, location_name, preview)
        @page_name = page_name
      end

      protected

      def asset_name
        "javascript"
      end

      def asset_class
        Javascript
      end

      def asset_ext
        "js"
      end

      def asset_file_name
        "#{@page_name.parameterize}-#{Time.now.to_i}"
      end

      def asset_path
        :js_path
      end

      def asset_url
        :include_path
      end
    end
  end
end

