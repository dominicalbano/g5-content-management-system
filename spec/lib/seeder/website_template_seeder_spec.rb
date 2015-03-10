require "spec_helper"

describe Seeder::WebsiteTemplateSeeder do
  let!(:client) { Fabricate(:client) }
  let!(:location) { Fabricate(:location) }
  let(:website) { Fabricate(:website, owner: location) }
  let(:defaults) { HashWithIndifferentAccess.new(YAML.load_file("#{Rails.root}/config/defaults/websites/defaults.yml")) }
  let(:instructions) { defaults[:website_template] }
  let(:seeder) { Seeder::WebsiteTemplateSeeder.new(website, instructions) }

  before do
    WebTemplate.any_instance.stub(:update_navigation_settings)
  end  

  describe "#seed" do
    let(:website_template_name) { instructions[:name] }
    let(:web_layout_name) { GardenWebLayout.find_by_slug(instructions[:web_layout][:slug]) }
    let(:web_theme_name) { GardenWebTheme.find_by_slug(instructions[:web_theme][:slug]) }
    let(:drop_targets_size) { instructions[:drop_targets].size }
    subject { seeder.seed }

    context "valid instructions" do
      before { subject }

      it "creates a website template for the website" do
        expect(website.website_template.name).to eq(website_template_name)
      end
      it "creates a web layout for the website" do
        expect(website.website_template.web_layout.name).to eq(web_layout_name)
      end
      it "creates a web theme for the website" do
        expect(website.website_template.web_theme.name).to eq(web_theme_name)
      end
      it "creates drop targets for the website" do
        expect(website.website_template.drop_targets.size).to eq(drop_targets_size)
      end
    end

    context "no instructions" do
      let(:instructions) { nil }
      it "raises a SyntaxError" do
        expect { subject }.to raise_error(SyntaxError)
      end
    end

    context "no website" do
      let(:website) { nil }
      it "raises a SyntaxError" do
        expect { subject }.to raise_error(SyntaxError)
      end
    end

    context "invalid instructions" do
      before { instructions.except!(:web_layout) }
      it "raises a SyntaxError" do
        expect { subject }.to raise_error(SyntaxError)
      end
    end
  end
end