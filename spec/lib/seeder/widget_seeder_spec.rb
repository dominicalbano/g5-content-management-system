require "spec_helper"

describe Seeder::WidgetSeeder do
  let!(:client) { Fabricate(:client) }
  let!(:location) { Fabricate(:location) }
  let(:website) { Fabricate(:website, owner: location) }
  let(:web_template) { Fabricate(:web_page_template, website: website)}
  let(:drop_target) { Fabricate(:drop_target, web_template: web_template) }
  let(:seeder) { Seeder::WidgetSeeder.new(drop_target, instructions) }
  
  let!(:html_widget) { Fabricate(:html_garden_widget) }
  let!(:meta_desc_widget) { Fabricate(:meta_description_garden_widget) }
  let!(:content_stripe_widget) { Fabricate(:row_garden_widget) }
  let!(:column_widget) { Fabricate(:column_garden_widget) }

  let!(:defaults) { HashWithIndifferentAccess.new(YAML.load_file("#{Rails.root}/spec/support/website_instructions/defaults_with_settings.yml")) }
  let(:meta_desc_instructions) { defaults[:web_home_template][:drop_targets].first[:widgets].first }
  let(:html_instructions) { defaults[:web_page_templates].first[:drop_targets].first[:widgets].first }
  let(:content_stripe_instructions) { defaults[:web_page_templates].second[:drop_targets].first[:widgets].first }
  let(:column_instructions) { defaults[:web_page_templates].third[:drop_targets].first[:widgets].first }

  describe "#seed" do
    subject { seeder.seed }

    context "non-layout widget" do
      context "valid instructions - no settings" do
        let(:instructions) { html_instructions }
        context "has drop target" do
          let(:instructions) { html_instructions }
          before { @response = subject }

          it "creates a widget in the drop target" do
            expect(drop_target.widgets.first.slug).to eq(html_widget.slug)
            expect(@response.slug).to eq(html_widget.slug)
            expect(@response.drop_target).to_not be_nil
          end
        end

        context "no drop target" do
          let(:drop_target) { nil }
          before { @response = subject }

          it "creates a stand-alone widget - no drop target" do
            expect(@response.slug).to eq(html_widget.slug)
            expect(@response.drop_target).to be_nil
          end
        end
      end

      context "valid instructions - with settings" do
        let(:instructions) { meta_desc_instructions }
        context "valid instructions - has settings, has drop target" do
          before { @response = subject }

          it "creates a widget in the drop target with settings" do
            expect(drop_target.widgets.first.slug).to eq(meta_desc_widget.slug)
            expect(@response.slug).to eq(meta_desc_widget.slug)
            expect(@response.drop_target).to_not be_nil
            expect(@response.get_setting('meta_description').value).to eq(instructions[:settings].first[:value])
          end
        end

        context "valid instructions - has settings, no drop target" do
          let(:drop_target) { nil }
          before { @response = subject }

          it "creates a standalone widget - no drop target - with settings" do
            expect(@response.slug).to eq(meta_desc_widget.slug)
            expect(@response.drop_target).to be_nil
            expect(@response.get_setting('meta_description').value).to eq(instructions[:settings].first[:value])
          end
        end
      end
    end

    context "content stripe widget" do
      let(:instructions) { content_stripe_instructions }
      context "valid instructions - has drop target (required), no widgets" do
        before { @response = subject }

        it "creates a content stripe widget in the drop target" do
          expect(drop_target.widgets.first.slug).to eq(content_stripe_widget.slug)
          expect(@response.slug).to eq(content_stripe_widget.slug)
          expect(@response.drop_target).to_not be_nil
        end
      end
    end

    context "column widget" do
      let(:instructions) { column_instructions }
      context "valid instructions - has drop target, no widgets" do
        before { @response = subject }

        it "creates a column widget in the drop target" do
          expect(drop_target.widgets.first.slug).to eq(column_widget.slug)
          expect(@response.slug).to eq(column_widget.slug)
          expect(@response.drop_target).to_not be_nil
        end
      end

      context "valid instructions - no drop target, no widgets" do
        let(:drop_target) { nil }
        before { @response = subject }

        it "creates a stand-alone widget - no drop target" do
          expect(@response.slug).to eq(column_widget.slug)
          expect(@response.drop_target).to be_nil
        end
      end
    end

    context "no instructions" do
      let(:instructions) { nil }
      subject { seeder.seed }
      before { @response = subject }
      it "logs error and returns nil" do
        expect(@response).to be_nil
      end
    end

    context "invalid instructions" do
      let(:instructions) { { wrong: true } }
      subject { seeder.seed }
      before { @response = subject }
      it "logs error and returns nil" do
        expect(@response).to be_nil
      end
    end
  end
end