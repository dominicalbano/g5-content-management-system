require "spec_helper"

describe StaticWebsite::Compiler::WebTemplates do
  describe "#compile" do
    context "when web templates is blank" do
      let(:subject) { StaticWebsite::Compiler::WebTemplates.new(nil) }

      it "does nothing" do
        expect(subject.compile).to be_nil
      end
    end

    context "when web templates are present" do
      let(:website) {Fabricate(:website)}
      let(:model_one) { Fabricate(:web_template) }
      let(:model_two) { Fabricate(:web_template) }
      let(:subject) { StaticWebsite::Compiler::WebTemplates.new([model_one, model_two]) }

      before do
        website.web_templates << [model_one, model_two]
      end

      it "compiles each one" do
        StaticWebsite::Compiler::WebTemplate.any_instance.stub(:compile)
        subject.should_receive(:compile_web_template).exactly(2).times
        expect(subject.compile).to eq subject.web_template_models
      end
    end
  end

  describe "#compile_web_template" do
    context "when web templates is blank" do
      let(:subject) { StaticWebsite::Compiler::WebTemplates.new(nil) }

      it "does nothing" do
        expect(subject.compile_web_template(nil)).to be_nil
      end
    end

    context "when web template is present" do
      let(:location) { Fabricate(:location) }
      let(:website) { Fabricate(:website, owner: location) }
      let(:model) { Fabricate(:web_page_template, website_id: website.id) }
      let(:subject) { StaticWebsite::Compiler::WebTemplates.new(nil) }
      let!(:client) { Fabricate(:client) }

      it "compiles web template" do
        StaticWebsite::Compiler::WebTemplate.any_instance.should_receive(:compile).once
        subject.compile_web_template(model)
      end
    end
  end
end
