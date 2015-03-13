require "spec_helper"

describe Seeder::ContentStripeWidgetSeeder do
  let!(:client) { Fabricate(:client) }
  let!(:location) { Fabricate(:location) }
  let(:website) { Fabricate(:website, owner: location) }
  let(:web_template) { Fabricate(:web_page_template, website: website) }
  let(:drop_target) { Fabricate(:drop_target, web_template: web_template) }
  let(:seeder) { Seeder::WidgetSeeder.new(drop_target, instructions) }
  
  # need to fabricate garden widgets for this to work
  let!(:html_widget) { Fabricate(:html_garden_widget) }
  let!(:map_widget) { Fabricate(:garden_widget, name: 'map') }
  let!(:gallery_widget) { Fabricate(:garden_widget, name: 'gallery') }
  let!(:column_widget) { Fabricate(:column_garden_widget) }
  let!(:content_stripe_widget) { Fabricate(:row_garden_widget) }

  let!(:defaults) { HashWithIndifferentAccess.new(YAML.load_file("#{Rails.root}/spec/support/website_instructions/defaults_with_settings.yml")) }
  let(:instructions) { defaults[:web_page_templates].second[:drop_targets].first[:widgets].first }

  describe "#seed" do
    context "content stripe widget" do
      subject { seeder.seed }
      
      context "valid instructions - single content stripe with widgets" do
        context "has drop target" do
          before { @response = subject }

          it "creates a content stripe widget in the drop target" do
            expect(drop_target.widgets.first.slug).to eq(content_stripe_widget.slug)
            expect(@response.drop_target).to_not be_nil
          end

          it "creates correct layout setting for content stripe widget" do
            expect(@response.settings.find_by_name('row_layout').value).to eq(instructions[:row_layout])
          end

          it "creates correct nested widget settings for content stripe widget" do
            expect(@response.child_widgets.size).to eq(instructions[:widgets].size)
            expect(@response.child_widgets.first.slug).to eq(instructions[:widgets].first[:slug])
            expect(@response.child_widgets.second.slug).to eq(instructions[:widgets].second[:slug])
            expect(@response.settings.find_by_name('column_one_widget_name').value).to eq(html_widget.name)
            expect(@response.settings.find_by_name('column_two_widget_name').value).to eq(map_widget.name)
          end
        end
      end

      context "valid instructions - content stripe with nested columns with widgets" do
        let(:instructions) { defaults[:web_page_templates].fourth[:drop_targets].first[:widgets].first }
        context "has drop target" do
          before do
            @response = subject
            @first_col = @response.child_widgets.first
            @second_col = @response.child_widgets.second
          end

          it "creates a content stripe widget in the drop target" do
            expect(drop_target.widgets.first.slug).to eq(content_stripe_widget.slug)
            expect(@response.drop_target).to_not be_nil
          end

          it "creates correct layout setting for content stripe widget" do
            expect(@response.settings.find_by_name('row_layout').value).to eq(instructions[:row_layout])
          end

          it "creates correct nested column widget settings for content stripe widget" do
            expect(@response.child_widgets.size).to eq(instructions[:widgets].size)
            expect(@first_col.slug).to eq(instructions[:widgets].first[:slug])
            expect(@second_col.slug).to eq(instructions[:widgets].second[:slug])
            expect(@response.settings.find_by_name('column_one_widget_name').value).to eq(column_widget.name)
            expect(@response.settings.find_by_name('column_two_widget_name').value).to eq(column_widget.name)
          end

          it "creates correct nested widget settings for nested column widgets inside content stripe widget" do
            expect(@first_col.child_widgets.size).to eq(instructions[:widgets].first[:widgets].size)
            expect(@second_col.child_widgets.size).to eq(instructions[:widgets].second[:widgets].size)
            expect(@first_col.child_widgets.first.slug).to eq(instructions[:widgets].first[:widgets].first[:slug])
            expect(@first_col.child_widgets.second.slug).to eq(instructions[:widgets].first[:widgets].second[:slug])
            expect(@second_col.child_widgets.first.slug).to eq(instructions[:widgets].second[:widgets].first[:slug])
          end
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