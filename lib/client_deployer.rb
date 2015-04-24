require "static_website/compiler/compile_directory"
require "static_website/compiler/area_pages"
require "client_deployer/base_compiler"
require "client_deployer/base_compiler/sitemap"
require "client_deployer/website_compiler"

module ClientDeployer
  def self.compile_and_deploy(client, user_email)
    compile_base_compiler
    area_pages_paths = compile_area_pages(client)
    compile_sitemap(client, area_pages_paths)
    compile_location_websites
    deployer(client, user_email).deploy
    cleanup(client.website.compile_path)
  end

  def self.base_compiler(client)
    ClientDeployer::BaseCompiler.new(client)
  end

  def self.compile_base_compiler(client)
    write_to_loggers("ClientDeployer: Sending compile to base_compiler")
    base_compiler(client).compile
  end

  def self.deployer(client, user_email)
    write_to_loggers("creating ClientDeployer::Deployer with #{client.to_s}, user: #{user_email}")
    ClientDeployer::Deployer.new(client, user_email)
  end

  def self.area_pages(compile_path)
    write_to_loggers("in area_pages with compile_path: #{compile_path}")
    StaticWebsite::Compiler::AreaPages.new(compile_path, Location.for_area_pages.map(&:website))
  end

  def self.compile_area_pages(client)
    write_to_loggers("ClientDeployer: Sending compile to AreaPages.new")
    area_page_paths = area_pages(client.website.compile_path).compile
  end

  def self.compile_sitemap(client, area_pages_paths)
    write_to_loggers("ClientDeployer:BaseCompiler::Sitemap with paths: #{area_page_paths.uniq.to_s}")
    ClientDeployer::BaseCompiler::Sitemap.new(client, area_page_paths.uniq).compile
  end

  def self.compile_location_websites
    write_to_loggers("compile_location_websites")
    Location.all.each {|location| WebsiteCompiler.new(location.website).compile }
  end

  def self.cleanup(compile_path)
    StaticWebsite::Compiler::CompileDirectory.new(compile_path, false).clean_up
  end
end

