require "spec_helper"

describe PhotoWidgetSeederSerializer do
  let!(:client) { Fabricate(:client) }
  let!(:location) { Fabricate(:location) }

  let!(:website) { Fabricate(:website, owner: location, website_template: web_template) }
  let!(:web_theme) { Fabricate(:web_theme, garden_web_theme: garden_web_theme) }
  let!(:garden_web_theme) { Fabricate(:garden_web_theme, primary_color: "#000000") }
  let!(:web_template) { Fabricate(:website_template, web_theme: web_theme) }

  let!(:page_template) { Fabricate(:web_page_template, website: website)}
  let(:drop_target) { Fabricate(:drop_target, web_template: page_template) }

  describe "#as_json" do
    context "photo widget seeder" do
      let(:garden_widget) { Fabricate(:photo_garden_widget) }
      let(:widget) { Fabricate(:widget, garden_widget: garden_widget, drop_target: drop_target) }
      let(:serializer) { WidgetSeederSerializer.new(widget) }
      
      let(:single) { "http://placehold.it/1140x705" }
      let(:two_thirds) { "http://placehold.it/760x470" }
      let(:halves) { "http://placehold.it/540x334" }
      let(:thirds) { "http://placehold.it/350x216" }
      let(:fourths) { "http://placehold.it/255x158" }

      subject { serializer.as_json }

      it "serializes the slug" do
        expect(subject[:slug]).to eq(garden_widget.slug)
      end

      context "has no photo_source_url setting" do
        context "has no parent content stripe" do
          it "returns the max sized placehold.it image" do
            expect(subject[:settings].first[:value]).to eq(single)
          end
        end

        context "has parent content stripe" do
        end
      end

      context "has photo_source_url setting" do
        before { widget.set_setting('photo_source_url', 'http://placehold.it/300x200') }

        it "serializes the photo_source_url setting" do
          expect(subject[:settings].first[:value]).to eq('http://placehold.it/300x200')
        end
      end

      context "has photo_link_url setting" do
        before { widget.set_setting('photo_link_url', 'http://getg5.com') }

        it "serializes the photo_link_url setting" do
          expect(subject[:settings].second[:value]).to eq('http://getg5.com')
        end
      end

      context "has photo_alt_tag setting" do
        before { widget.set_setting('photo_alt_tag', 'test') }

        it "serializes the photo_alt_tag setting" do
          expect(subject[:settings].second[:value]).to eq('test')
        end
      end

      context "has photo_caption setting" do
        before { widget.set_setting('photo_caption', 'test caption') }

        it "serializes the photo_caption setting" do
          expect(subject[:settings].second[:value]).to eq('test caption')
        end
      end

      context "has photo_alignment setting" do
        before { widget.set_setting('photo_alignment', 'left') }

        it "serializes the photo_alignment setting" do
          expect(subject[:settings].second[:value]).to eq('left')
        end
      end

      context "has photo_class setting" do
        before { widget.set_setting('photo_class', 'custom') }

        it "serializes the photo_class setting" do
          expect(subject[:settings].second[:value]).to eq('custom')
        end
      end
    end
  end
end