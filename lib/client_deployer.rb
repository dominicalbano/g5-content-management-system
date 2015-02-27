require "static_website/compiler/compile_directory"
require "static_website/compiler/area_pages"
require "client_deployer/base_compiler"
require "client_deployer/website_compiler"

LOGGERS = [Rails.logger, Resque.logger]

module ClientDeployer
  def self.compile_and_deploy(client, user_email)
    LOGGERS.each {|logger| logger.debug("ClientDeployer: Sending compile to base_compiler")}
    base_compiler(client).compile
    area_pages(client.website.compile_path).compile
    compile_location_websites
    deployer(client, user_email).deploy
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
    Location.each {|location| WebsiteCompiler.new(location.website).compile }
  end

  def self.cleanup(compile_path)
    StaticWebsite::Compiler::CompileDirectory.new(compile_path, false).clean_up
  end
end

