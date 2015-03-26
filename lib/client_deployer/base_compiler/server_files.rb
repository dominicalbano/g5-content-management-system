require "client_deployer/base_compiler/htaccess"
require "client_deployer/base_compiler/sitemap"
require "client_deployer/base_compiler/robots"

module ClientDeployer
  module BaseCompiler
    class ServerFiles
      def self.compile
        client = Client.first
        HTAccess.new(client).compile

        LOGGERS.each{|logger| logger.debug("doing sitemapfreal")}
        Sitemap.new(client).compile
        LOGGERS.each{|logger| logger.debug("doing robots")}
        Robots.new(client).compile
      end
    end
  end
end
