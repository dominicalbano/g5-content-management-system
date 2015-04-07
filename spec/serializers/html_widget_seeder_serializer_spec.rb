require "spec_helper"

describe HtmlWidgetSeederSerializer do
  let!(:client) { Fabricate(:client) }
  let!(:location) { Fabricate(:location) }

  let!(:website) { Fabricate(:website, owner: location, website_template: web_template) }
  let!(:web_theme) { Fabricate(:web_theme, garden_web_theme: garden_web_theme) }
  let!(:garden_web_theme) { Fabricate(:garden_web_theme, primary_color: "#000000") }
  let!(:web_template) { Fabricate(:website_template, web_theme: web_theme) }

  let!(:page_template) { Fabricate(:web_page_template, website: website)}
  let(:drop_target) { Fabricate(:drop_target, web_template: page_template) }

  describe "#as_json" do
    context "html widget seeder" do
      let(:garden_widget) { Fabricate(:html_garden_widget) }
      let(:widget) { Fabricate(:widget, garden_widget: garden_widget, drop_target: drop_target) }
      let(:serializer) { WidgetSeederSerializer.new(widget) }
      subject { serializer.as_json }

      context "has no text setting" do
        it "serializes the slug" do
          expect(subject[:slug]).to eq(garden_widget.slug)
        end

        it "serializes the default value for text setting" do
          expect(subject[:settings]).to_not be_empty
          expect(subject[:settings].first[:value]).to eq(widget.get_setting('text').default_value)
        end
      end

      context "has settings" do
        before { widget.set_setting('text', 'test') }
        it "serializes the slug" do
          expect(subject[:slug]).to eq(garden_widget.slug)
        end

        it "serializes the text setting" do
          expect(subject[:settings]).to_not be_empty
          expect(subject[:settings].first[:value]).to eq(widget.get_setting_value('text'))
        end
      end
    end
  end
end