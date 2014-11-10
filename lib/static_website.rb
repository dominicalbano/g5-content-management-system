require "static_website/compiler"
require "static_website/deployer"

LOGGERS = [Rails.logger, Resque.logger]

module StaticWebsite
  def self.compile_and_deploy(website, user_email)
    compile(website)
    deploy(website, user_email)
  end

  def self.compile(website)
    LOGGERS.each{|logger| logger.info("Compiling website")}
    Compiler.new(website).compile
  end

  def self.deploy(website, user_email)
    LOGGERS.each{|logger| logger.info("Deploying website")}
    Deployer.new(website, user_email).deploy
  end
end

