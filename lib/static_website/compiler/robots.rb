module StaticWebsite
  module Compiler
    class Robots

      def initialize(website)
        @heroku_app = "http://#{WebsiteDecorator.decorate(website).heroku_app_name}.herokuapp.com"
        @website_compile_path = website.compile_path
      end

      def compile_path
        File.join(@website_compile_path.to_s, "robots.txt")
      end

      def compile
        compile_directory.find_or_make_dir
        render_to_file
      end

      def compile_directory
        @compile_directory ||= CompileDirectory.new(compile_path, false)
      end

      def render_robots
        robots_contents = ["Sitemap: #{File.join(@heroku_app, 'sitemap.xml')}"]

        return robots_contents.flatten.join("\n")
      end

      private

      def render_to_file
        open(compile_path, "wb") do |file|
          file << render_robots
        end if compile_path
      end
    end
  end
end
