require "client_deployer/website_compiler/website"

module ClientDeployer::WebsiteCompiler
  def self.new(website)
    write_to_loggers("returning website object for #{website.to_s}")
    ClientDeployer::WebsiteCompiler::Website.new(website)
  end
end
