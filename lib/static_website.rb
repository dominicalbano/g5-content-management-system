require "static_website/compiler"
require "static_website/deployer"

module StaticWebsite
  def self.compile_and_deploy(website, user_email)
    compile(website)
    deploy(website, user_email)
  end

  def self.compile(website)
    LOGGERS.each{|logger| logger.info("Compiling: #{website.urn}")}
    Compiler.new(website).compile
  end

  def self.deploy(website, user_email)
    LOGGERS.each{|logger| logger.info("Deploying website: #{website.urn}")}
    Deployer.new(website, user_email).deploy
  end

  def self.single_domain_client?
    Client.first.type == "SingleDomainClient"
  end
end

