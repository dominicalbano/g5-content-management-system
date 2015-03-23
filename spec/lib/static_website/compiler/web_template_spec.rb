require "spec_helper"

describe StaticWebsite::Compiler::WebTemplate do
  let!(:client) { Fabricate(:client) }
  let(:location) { Fabricate(:location) }
  let(:website) { Fabricate(:website, owner: location) }
  let(:web_template) { Fabricate(:web_home_template, website_id: website.id) }
  let(:web_layout) { Fabricate(:web_layout) }

  before do
    web_template.stub(:update_navigation_settings)
    web_template.stub(:website_layout).and_return(web_layout)
  end 

  describe "#compile" do
    let(:subject) { StaticWebsite::Compiler::WebTemplate.new(web_template) }

    it "compiles view" do
      subject.view.should_receive(:compile).once
      subject.compile
    end
  end

  describe "#view" do
    let(:subject) { StaticWebsite::Compiler::WebTemplate.new(web_template) }

    it "is a view object" do
      expect(subject.view).to be_a StaticWebsite::Compiler::View
    end
  end

  describe "#view.compile" do
    context "when web template is blank" do
      let(:subject) { StaticWebsite::Compiler::WebTemplate.new(nil) }

      it "does nothing" do
        expect(subject.view.compile).to be_nil
      end
    end

    context "when compile path is present", vcr: VCR_OPTIONS do
      let(:compile_path) { File.join(Rails.root, "tmp", "spec", "web_template", "show.html") }
      let(:subject) { StaticWebsite::Compiler::WebTemplate.new(web_template) }

      before do
        FileUtils.rm(compile_path, force: true) if File.exists?(compile_path)
        subject.stub(:compile_path).and_return(compile_path)
      end

      after do
        FileUtils.rm(compile_path, force: true) if File.exists?(compile_path)
      end

      it "writes file to compile path" do
        expect(File.exists?(subject.compile_path)).to be_falsey
        subject.view.compile
        expect(File.exists?(subject.compile_path)).to be_truthy
      end
    end
  end

  describe "#view_path" do
    let(:subject) { StaticWebsite::Compiler::WebTemplate.new(web_template) }

    it "is the web templates show view" do
      expect(subject.view_path).to eq "web_templates/show"
    end
  end

  describe "#view_options" do
    let(:subject) { StaticWebsite::Compiler::WebTemplate.new(web_template) }

    it "uses web template layout" do
      expect(subject.view_options).to include(layout: "web_template")
    end

    it "sets local web template" do
      expect(subject.view_options[:locals]).to include(web_template: subject.web_template)
    end

    it "sets local mode to deployed" do
      expect(subject.view_options[:locals]).to include(mode: "deployed")
    end
  end
end

