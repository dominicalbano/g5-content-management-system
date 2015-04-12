require "static_website/compiler/compile_directory"

module StaticWebsite
  module Compiler
    class View
      attr_reader :view_path, :view_options, :compile_path

      def initialize(view_path, view_options, compile_path)
        @view_path = view_path
        @view_options = view_options
        @compile_path = compile_path
      end

      def compile
        compile_directory.compile
        render_to_file
      end

      def compile_directory
        @compile_directory ||= CompileDirectory.new(compile_path, false)
      end

      private

      def render_to_file
        LOGGERS.each{|logger| logger.info("Rending HTML for #{compile_path}")}
        File.open(compile_path, "w") do |file|
          file << ApplicationController.new.render_to_string(view_path, view_options)
        end if compile_path
      end
    end
  end
end
