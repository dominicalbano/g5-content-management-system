require "static_website/compiler"
require "static_website/deployer"

module StaticWebsite
  def self.compile_and_deploy(website, user_email)
    compile(website)
    deploy(website, user_email)
  end

  def self.compile(website)
    Compiler.new(website).compile
  end

  def self.deploy(website, user_email)
    Deployer.new(website, user_email).deploy
  end
end
