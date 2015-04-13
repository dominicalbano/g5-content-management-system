require "client_deployer/base_compiler/htaccess"
require "client_deployer/base_compiler/robots"

module ClientDeployer
  module BaseCompiler
    class BaseFiles
      def initialize(client)
        @client = client
      end

      def compile
        HTAccess.new(@client).compile
        Robots.new(@client).compile
      end
    end
  end
end
