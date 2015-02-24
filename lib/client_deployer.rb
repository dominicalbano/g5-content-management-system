require "static_website/compiler/compile_directory"
require "static_website/compiler/area_pages"
require "client_deployer/base_compiler"
require "client_deployer/website_compiler"

LOGGERS = [Rails.logger, Resque.logger]

module ClientDeployer
  def self.compile_and_deploy(client, user_email)
    LOGGERS.each {|logger| logger.debug("Sending compile to base_compiler")}
    base_compiler(client).compile
    LOGGERS.each {|logger| logger.info("Sending compile to area_pages(client.website.compile_path): #{client.website.compile_path}" )}
    area_pages(client.website.compile_path).compile
    LOGGERS.each {|logger| logger.info("Calling compile_location_websites")}
    compile_location_websites
    LOGGERS.each {|logger| logger.info("Sending client to deployer and sending deploy")}
    deployer(client, user_email).deploy
    LOGGERS.each {|logger| logger.debug("Calling cleanup with path: #{client.website.compile_path}")}
    cleanup(client.website.compile_path)
  end

  def self.base_compiler(client)
    ClientDeployer::BaseCompiler.new(client)
  end

  def self.deployer(client, user_email)
    LOGGERS.each {|logger| logger.debug("creating ClientDeployer::Deployer with #{client.to_s}, user: #{user_email}")}
    ClientDeployer::Deployer.new(client, user_email)
  end

  def self.area_pages(compile_path)
    LOGGERS.each {|logger| logger.debug("in area_pages with compile_path: #{compile_path}")}
    StaticWebsite::Compiler::AreaPages.new(compile_path, Location.live_websites)
  end

  def self.compile_location_websites
    LOGGERS.each {|logger| logger.debug("compile_location_websites")}
    LOGGERS.each {|logger| logger.debug("calling compile on WebsiteCompiler for each of #{Website.location_websites.to_s}")}
    Website.location_websites.each { |website| WebsiteCompiler.new(website).compile }
  end

  def self.cleanup(compile_path)
    StaticWebsite::Compiler::CompileDirectory.new(compile_path, false).clean_up
  end
end

