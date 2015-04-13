require "spec_helper"

describe StaticWebsite::Compiler::Sitemap do
  let!(:client) {Fabricate(:client)}
  let!(:website) {Fabricate(:website)}
  let!(:web_home_template) {Fabricate(:web_home_template, website: website)}
  let!(:web_page_template) {Fabricate(:web_page_template, website: website)}

  describe "#compile" do

    before do
      FakeFS.activate!
      sitemap = described_class.new(website, ['/area/one','/area/two'])
      sitemap.compile
    end 

    after do
      FakeFS.deactivate!
    end

    it "creates sitemap file" do
      File.exists?(File.join("#{website.compile_path}", "sitemap.xml")).should eq(true)
    end

    it "renders into the file" do
      contents = File.open(File.join("#{website.compile_path}", "sitemap.xml")).read
      contents.should include(web_home_template.owner_domain)
      contents.should include(web_page_template.slug)
      puts contents
    end

  end
end

