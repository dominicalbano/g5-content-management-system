require "spec_helper"

describe Seeder::WebLayoutSeeder do
  let!(:client) { Fabricate(:client) }
  let!(:location) { Fabricate(:location) }
  let(:website) { Fabricate(:website, owner: location) }
  let(:website_template) { Fabricate(:website_template, website: website) }
  let(:defaults) { HashWithIndifferentAccess.new(YAML.load_file("#{Rails.root}/config/defaults/websites/defaults.yml")) }
  let(:instructions) { defaults[:website_template][:web_layout] }
  let(:seeder) { Seeder::WebLayoutSeeder.new(website_template, instructions) }

  describe "#seed" do
    let(:web_layout_name) { GardenWebLayout.find_by_slug(instructions[:slug]) }
    subject { seeder.seed }

    context "valid instructions" do
      before { subject }

      it "creates a web layout for the web template" do
        expect(website_template.web_layout.name).to eq(web_layout_name)
      end
    end

    context "no instructions" do
      let(:instructions) { nil }
      it "raises a SyntaxError" do
        expect { subject }.to raise_error(SyntaxError)
      end
    end

    context "no website template" do
      let(:website_template) { nil }
      it "raises a SyntaxError" do
        expect { subject }.to raise_error(SyntaxError)
      end
    end

    context "invalid instructions" do
      before { instructions.except!(:slug) }
      it "raises a SyntaxError" do
        expect { subject }.to raise_error(SyntaxError)
      end
    end
  end
end