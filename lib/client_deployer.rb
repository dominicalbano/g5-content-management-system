require "static_website/compiler/compile_directory"
require "static_website/compiler/area_pages"
require "client_deployer/base_compiler"
require "client_deployer/website_compiler"

module ClientDeployer
  def self.compile_and_deploy(client)
    base_compiler(client).compile
    area_pages(client.website.compile_path).compile
    compile_location_websites
    deployer(client).deploy
    cleanup(client.website.compile_path)
  end

  def self.base_compiler(client)
    ClientDeployer::BaseCompiler.new(client)
  end

  def self.deployer(client)
    ClientDeployer::Deployer.new(client)
  end

  def self.area_pages(compile_path)
    StaticWebsite::Compiler::AreaPages.new(compile_path, location_websites)
  end

  def self.compile_location_websites
    location_websites.each { |website| WebsiteCompiler.new(website).compile }
  end

  def self.cleanup(compile_path)
    StaticWebsite::Compiler::CompileDirectory.new(compile_path, false).clean_up
  end

  def self.location_websites
    Website.live_location_websites
  end
end
