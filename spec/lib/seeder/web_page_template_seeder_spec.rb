require "spec_helper"

describe Seeder::WebPageTemplateSeeder do
  let!(:client) { Fabricate(:client) }
  let!(:location) { Fabricate(:location) }
  let(:website) { Fabricate(:website, owner: location) }
  let(:defaults) { HashWithIndifferentAccess.new(YAML.load_file("#{Rails.root}/config/defaults/websites/defaults.yml")) }
  let(:web_home_instructions) { defaults[:web_home_template] }
  let(:web_page_instructions) { defaults[:web_page_templates].first }

  describe "#seed" do
    context "web home template" do
      let(:seeder) { Seeder::WebPageTemplateSeeder.new(website, web_home_instructions, true) }
      let(:page_name) { web_home_instructions[:name] }
      let(:drop_targets_count) { web_home_instructions[:drop_targets].size }
      subject { seeder.seed }

      context "valid instructions" do
        before { @response = subject }
        it "creates a new home page template" do
          expect(@response.name).to eq(page_name)
          expect(@response.drop_targets.size).to eq(drop_targets_count)
        end
      end

      context "no instructions" do
        let(:web_home_instructions) { nil }
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

      context "invalid instructions - no name" do
        before { web_home_instructions.except!(:name) }
        it "raises a SyntaxError" do
          expect { subject }.to raise_error(SyntaxError)
        end
      end

      context "invalid instructions - no drop targets" do
        before { web_home_instructions.except!(:drop_targets) }
        it "raises a SyntaxError" do
          expect { subject }.to raise_error(SyntaxError)
        end
      end
    end

    context "web page template" do
      let(:seeder) { Seeder::WebPageTemplateSeeder.new(website, web_page_instructions, false) }
      let(:page_name) { web_page_instructions[:name] }
      let(:drop_targets_count) { web_page_instructions[:drop_targets].size }
      subject { seeder.seed }

      context "valid instructions" do
        before { @response = subject }
        it "creates a new internal page template" do
          expect(@response.name).to eq(page_name)
          expect(@response.drop_targets.size).to eq(drop_targets_count)
        end
      end

      context "no instructions" do
        let(:web_page_instructions) { nil }
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

      context "invalid instructions - no name" do
        before { web_page_instructions.except!(:name) }
        it "raises a SyntaxError" do
          expect { subject }.to raise_error(SyntaxError)
        end
      end

      context "invalid instructions - no drop targets" do
        before { web_page_instructions.except!(:drop_targets) }
        it "raises a SyntaxError" do
          expect { subject }.to raise_error(SyntaxError)
        end
      end
    end
  end
end