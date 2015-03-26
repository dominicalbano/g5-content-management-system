require "static_website/compiler/compile_directory"
require "static_website/compiler/area_pages"
#require "client_deployer/base_compiler"
require "client_deployer/base_compiler/server_files"
require "client_deployer/website_compiler"


module ClientDeployer
  def self.compile_and_deploy(client, user_email)
    ClientDeployer::BaseCompiler::ServerFiles.compile
    #area_pages(client.website.compile_path).compile
    StaticWebsite::Compiler::AreaPages.new(client.website.compile_path, Location.live_websites)
    compile_location_websites
    deployer(client, user_email).deploy
    cleanup(client.website.compile_path)
  end

  #def self.base_compiler(client)
    #ClientDeployer::BaseCompiler.new(client)
  #end

  def self.deployer(client, user_email)
    ClientDeployer::Deployer.new(client, user_email)
  end

  def self.area_pages(compile_path)
    StaticWebsite::Compiler::AreaPages.new(compile_path, Location.live_websites)
  end

  def self.compile_location_websites
    Location.all.each {|location| WebsiteCompiler.new(location.website).compile }
  end

  def self.cleanup(compile_path)
    StaticWebsite::Compiler::CompileDirectory.new(compile_path, false).clean_up
  end
end

