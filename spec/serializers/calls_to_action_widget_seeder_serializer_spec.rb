require "spec_helper"

describe CallsToActionWidgetSeederSerializer do
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
      let(:garden_widget) { Fabricate(:calls_to_action_garden_widget) }
      let(:widget) { Fabricate(:widget, garden_widget: garden_widget, drop_target: drop_target) }
      let(:serializer) { WidgetSeederSerializer.new(widget) }
      subject { serializer.as_json }

      context "has no text setting" do
        it "serializes the slug" do
          expect(subject[:slug]).to eq(garden_widget.slug)
        end

        it "serializes the empty settings" do
          expect(subject[:settings]).to be_empty
        end
      end

      context "has text for first cta" do
        before do
          widget.set_setting('cta_text_1', 'test')
          widget.set_setting('page_slug_1', 'test-page')
        end
        it "serializes the slug" do
          expect(subject[:slug]).to eq(garden_widget.slug)
          expect(subject[:settings]).to_not be_empty
        end

        it "serializes the cta text setting" do
          expect(subject[:settings].first[:value]).to eq(widget.get_setting_value('cta_text_1'))
        end

        it "serializes the cta page slug setting" do
          expect(subject[:settings].second[:value]).to eq(widget.get_setting_value('page_slug_1'))
        end
      end

      context "has text for all four ctas" do
        before do
          widget.set_setting('cta_text_1', 'test')
          widget.set_setting('page_slug_1', 'test-page')
          widget.set_setting('cta_text_2', 'test2')
          widget.set_setting('page_slug_2', 'test-page2')
          widget.set_setting('cta_text_3', 'test3')
          widget.set_setting('page_slug_3', 'test-page3')
          widget.set_setting('cta_text_4', 'test4')
          widget.set_setting('page_slug_4', 'test-page4')
        end
        it "serializes the slug" do
          expect(subject[:slug]).to eq(garden_widget.slug)
          expect(subject[:settings]).to_not be_empty
        end

        it "serializes all cta text settings" do
          expect(subject[:settings][0][:value]).to eq(widget.get_setting_value('cta_text_1'))
          expect(subject[:settings][2][:value]).to eq(widget.get_setting_value('cta_text_2'))
          expect(subject[:settings][4][:value]).to eq(widget.get_setting_value('cta_text_3'))
          expect(subject[:settings][6][:value]).to eq(widget.get_setting_value('cta_text_4'))
        end

        it "serializes all cta page slug setting" do
          expect(subject[:settings][1][:value]).to eq(widget.get_setting_value('page_slug_1'))
          expect(subject[:settings][3][:value]).to eq(widget.get_setting_value('page_slug_2'))
          expect(subject[:settings][5][:value]).to eq(widget.get_setting_value('page_slug_3'))
          expect(subject[:settings][7][:value]).to eq(widget.get_setting_value('page_slug_4'))
        end
      end

      context "has cta with no text" do
        before do
          widget.set_setting('cta_text_1', 'test')
          widget.set_setting('page_slug_1', 'test-page')
          widget.set_setting('page_slug_2', 'test-page2')
        end
        it "serializes the slug" do
          expect(subject[:slug]).to eq(garden_widget.slug)
          expect(subject[:settings]).to_not be_empty
        end

        it "serializes only cta text settings with length" do
          expect(subject[:settings][0][:value]).to eq(widget.get_setting_value('cta_text_1'))
          expect(subject[:settings].size).to eq(2)
        end

        it "serializes only cta page slug setting with matching cta text" do
          expect(subject[:settings][1][:value]).to eq(widget.get_setting_value('page_slug_1'))
        end
      end
    end
  end
end