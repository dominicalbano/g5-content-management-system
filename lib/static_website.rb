require "static_website/compiler"
require "static_website/deployer"

module StaticWebsite
  def self.compile_and_deploy(website)
    compile(website) && deploy(website)
  end

  def self.compile(website)
    Compiler.new(website).compile
  end

  def self.compile_area_pages(website)
    if website.owner.corporate?
      AreaPages.new(website.compile_path, Website.location_websites).compile
    end
  end

  def self.deploy(website)
    Deployer.new(website).deploy
  end
end
