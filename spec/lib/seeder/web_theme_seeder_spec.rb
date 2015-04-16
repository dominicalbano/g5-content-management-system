require "spec_helper"

describe Seeder::WebThemeSeeder do
  let!(:client) { Fabricate(:client) }
  let!(:location) { Fabricate(:location) }
  let(:website) { Fabricate(:website, owner: location) }
  let(:website_template) { Fabricate(:website_template, website: website) }
  let(:defaults) { load_website_yaml_file("defaults") }
  let(:instructions) { defaults[:website_template][:web_theme] }
  let(:seeder) { Seeder::WebThemeSeeder.new(website_template, instructions) }

  describe "#seed" do
    let(:web_theme_name) { GardenWebTheme.find_by_slug(instructions[:slug]) }
    subject { seeder.seed }

    context "valid instructions" do
      before { subject }

      it "creates a web theme for the web template" do
        expect(website_template.web_theme.name).to eq(web_theme_name)
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