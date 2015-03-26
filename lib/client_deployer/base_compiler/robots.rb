require "static_website/compiler/compile_directory"

module ClientDeployer
  module BaseCompiler
    class Robots
      def initialize(client)
        @website = client.website
        @heroku_app = "http://#{WebsiteDecorator.decorate(@website).heroku_app_name}.herokuapp.com"
        @website_compile_path = @website.compile_path
      end

      def compile
        compile_directory.find_or_make_dir
        render_to_file
      end

    private

      def compile_path
        File.join(@website_compile_path.to_s, "robots.txt")
      end

      def compile_directory
        StaticWebsite::Compiler::CompileDirectory.new(compile_path, false)
      end

      def render_robots
        robots_contents = ["Sitemap: #{File.join(@heroku_app, 'sitemap.xml')}"]

        return robots_contents.flatten.join("\n")
      end


      def render_to_file
        open(compile_path, "wb") do |file|
          file << render_robots
        end if compile_path
      end
    end
  end
end
