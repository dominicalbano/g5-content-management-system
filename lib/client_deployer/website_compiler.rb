require "client_deployer/website_compiler/website"

module ClientDeployer::WebsiteCompiler
  def self.new(website)
    LOGGERS.each {|logger| logger.debug("returning websitewcompiler::website object for #{website.inspect.to_s}")}
    ClientDeployer::WebsiteCompiler::Website.new(website)
  end
end
