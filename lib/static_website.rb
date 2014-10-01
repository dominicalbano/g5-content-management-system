require "static_website/compiler"
require "static_website/deployer"
require "static_website/compiler/area_pages"

module StaticWebsite
  def self.compile_and_deploy(website, user_email)
    compile(website)
    compile_area_pages(website) if website.owner.corporate?
    deploy(website, user_email)
  end

  def self.compile(website)
    Compiler.new(website).compile
  end

  def self.compile_area_pages(website)
    StaticWebsite::Compiler::AreaPages.new(website.compile_path, Website.location_websites).compile
  end

  def self.deploy(website, user_email)
    Deployer.new(website, user_email).deploy
  end
end
