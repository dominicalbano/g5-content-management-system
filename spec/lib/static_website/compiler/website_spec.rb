require "spec_helper"

describe StaticWebsite::Compiler::Website do
  let!(:client) { Fabricate(:client) }
  let(:website) { Fabricate(:website) }

  describe "#compile" do
    let(:subject) { StaticWebsite::Compiler::Website.new(website) }

    before do
      StaticWebsite::Compiler::Javascript::Uploader.any_instance.stub(:compile) { true }
      StaticWebsite::Compiler::Stylesheet::Uploader.any_instance.stub(:compile) { true }
      StaticWebsite::Compiler::Sitemap.any_instance.stub(:compile) {true}
    end

    it "compiles stylesheets" do
      subject.stylesheets.should_receive(:compile).once
      subject.compile
    end

    it "compiles web home template" do
      subject.web_home_template.should_receive(:compile).once
      subject.compile
    end
  end

  describe "#compile_directory" do
    let(:subject) { StaticWebsite::Compiler::Website.new(website) }

    it "is a compile directory object" do
      expect(subject.compile_directory).to be_a StaticWebsite::Compiler::CompileDirectory
    end
  end

  describe "#stylesheets" do
    let(:subject) { StaticWebsite::Compiler::Website.new(website) }

    it "is a stylesheets object" do
      expect(subject.stylesheets).to be_a StaticWebsite::Compiler::Stylesheets
    end
  end

  describe "#location_name" do
    let(:location) { Fabricate(:location, name: "North Shore Oahu") }
    let(:subject) { StaticWebsite::Compiler::Website.new(website) }

    before do
      website.owner = location
    end

    it "is the name of the location" do
      expect(subject.location_name).to eq "North Shore Oahu"
    end
  end

  describe "#web_home_template" do
    let(:subject) { StaticWebsite::Compiler::Website.new(website) }

    it "is a web template object" do
      expect(subject.web_home_template).to be_a StaticWebsite::Compiler::WebTemplate
    end
  end

  describe "#web_page_templates" do
    let(:subject) { StaticWebsite::Compiler::Website.new(website) }

    it "is a web templates object" do
      expect(subject.web_page_templates).to be_a StaticWebsite::Compiler::WebTemplates
    end
  end
end
