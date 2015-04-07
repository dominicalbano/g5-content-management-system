require "spec_helper"

describe LogoWidgetSeederSerializer do
  let!(:client) { Fabricate(:client) }
  let!(:location) { Fabricate(:location) }

  let!(:website) { Fabricate(:website, owner: location, website_template: web_template) }
  let!(:web_theme) { Fabricate(:web_theme, garden_web_theme: garden_web_theme) }
  let!(:garden_web_theme) { Fabricate(:garden_web_theme, primary_color: "#000000") }
  let!(:web_template) { Fabricate(:website_template, web_theme: web_theme) }

  let!(:page_template) { Fabricate(:web_page_template, website: website)}
  let(:drop_target) { Fabricate(:drop_target, web_template: page_template) }

  describe "#as_json" do
    context "logo widget seeder" do
      let(:garden_widget) { Fabricate(:logo_garden_widget) }
      let(:widget) { Fabricate(:widget, garden_widget: garden_widget, drop_target: drop_target) }
      let(:serializer) { WidgetSeederSerializer.new(widget) }
      subject { serializer.as_json }

      context "has no settings" do
        it "serializes the slug" do
          expect(subject[:slug]).to eq(garden_widget.slug)
          expect(subject[:settings]).to be_empty
        end
      end

      context "has business name" do
        before { widget.set_setting('business_name', 'test') }

        it "serializes the business name" do
          expect(subject[:settings]).to_not be_empty
          expect(subject[:settings].first[:value]).to eq(widget.get_setting_value('business_name'))
        end
      end

      context "has display logo" do
        before { widget.set_setting('display_logo', true) }

        it "serializes the business name" do
          expect(subject[:settings]).to_not be_empty
          expect(subject[:settings].first[:value]).to eq(widget.get_setting_value('display_logo'))
        end
      end

      context "has logo url" do
        before { widget.set_setting('logo_url', 'http://placehold.it/300x200') }

        it "serializes the business name" do
          expect(subject[:settings]).to_not be_empty
          expect(subject[:settings].first[:value]).to eq(widget.get_setting_value('logo_url'))
        end
      end
    end
  end
end