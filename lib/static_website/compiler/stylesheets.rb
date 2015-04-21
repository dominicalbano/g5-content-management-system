require "static_website/compiler/stylesheet"
require "static_website/compiler/stylesheet/colors"
require "static_website/compiler/stylesheet/compressor"

module StaticWebsite
  module Compiler
    class Stylesheets < StaticWebsite::Compiler::Assets

      attr_reader :colors, :fonts

      def initialize(stylesheet_paths, compile_path, colors={}, fonts={}, location_name="", preview=false)
        super(stylesheet_paths, compile_path, location_name, preview)
        @colors = colors
        @fonts = fonts
      end

      def compile
        unless @paths.empty?
          colors_stylesheet.compile
          fonts_stylesheet.compile
        end
        super
      end

      def colors_stylesheet
        @colors_stylesheet ||= Stylesheet::Colors.new(colors, compile_path)
      end

      def fonts_stylesheet
        @fonts_stylesheet ||= Stylesheet::Fonts.new(fonts, compile_path)
      end

      protected

      def asset_name
        "stylesheet"
      end

      def asset_class
        Stylesheet
      end

      def asset_ext
        "css"
      end

      def asset_file_name
        "application"
      end

      def asset_path
        :css_path
      end

      def asset_url
        :link_path
      end
    end
  end
end
