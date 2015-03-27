require "spec_helper"

describe MetaDescriptionWidgetSeederSerializer do
  let!(:client) { Fabricate(:client) }
  let!(:location) { Fabricate(:location) }

  let!(:website) { Fabricate(:website, owner: location, website_template: web_template) }
  let!(:web_theme) { Fabricate(:web_theme, garden_web_theme: garden_web_theme) }
  let!(:garden_web_theme) { Fabricate(:garden_web_theme, primary_color: "#000000") }
  let!(:web_template) { Fabricate(:website_template, web_theme: web_theme) }

  let!(:page_template) { Fabricate(:web_page_template, website: website)}
  let(:drop_target) { Fabricate(:drop_target, web_template: page_template) }

  describe "#as_json" do
    context "meta description widget seeder" do
      let(:garden_widget) { Fabricate(:meta_description_garden_widget) }
      let(:widget) { Fabricate(:widget, garden_widget: garden_widget, drop_target: drop_target) }
      let(:serializer) { WidgetSeederSerializer.new(widget) }
      subject { serializer.as_json }

      context "has no settings" do
        it "serializes the slug" do
          expect(subject[:slug]).to eq(garden_widget.slug)
          expect(subject[:settings]).to be_empty
        end
      end

      context "has settings" do
        before { widget.set_setting('meta_description', 'test') }
        it "serializes the slug" do
          expect(subject[:slug]).to eq(garden_widget.slug)
        end

        it "serializes the meta_description setting" do
          expect(subject[:settings]).to_not be_empty
          expect(subject[:settings].first[:value]).to eq(widget.get_setting_value('meta_description'))
        end
      end

      context "reverse liquid" do
        let(:meta_desc) { "Test #{client.name} Description" }
        before do
          widget.set_setting('meta_description', meta_desc)
        end
        context "uses reverse liquid" do
          it "reverse encodes setting values to include liquid variables" do
            expect(subject[:settings].first[:value]).to include "{{client_name}}"
          end
        end

        context "does not use reverse liquid" do
          before do
            MetaDescriptionWidgetSeederSerializer.any_instance.stub(:use_reverse_liquid?).and_return(false)
          end
          it "leaves setting value intact" do
            expect(subject[:settings].first[:value]).to include meta_desc
          end
        end
      end
    end
  end
end