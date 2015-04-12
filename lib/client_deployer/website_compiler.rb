require "client_deployer/website_compiler/website"

module ClientDeployer::WebsiteCompiler
  def self.new(website)
    ClientDeployer::WebsiteCompiler::Website.new(website)
  end
end
