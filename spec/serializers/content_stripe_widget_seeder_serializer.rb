require 'spec_helper'

describe ContentStripeWidgetSeederSerializer do
  let(:cs_garden_widget) { Fabricate(:row_garden_widget) }
  let(:garden_widget) { Fabricate(:garden_widget) }
  let(:other_garden_widget) { Fabricate(:html_garden_widget) }
  let(:cs_widget) { Fabricate(:widget, garden_widget: cs_garden_widget) }
  
  before do
    cs_widget.set_setting('row_layout', 'halves')
    cs_widget.reload
  end

  subject { WidgetSeederSerializer.new(cs_widget).as_json(root: false) }

  describe "#as_json" do
    it "serializes the slug" do
      expect(subject[:slug]).to eq col_garden_widget.slug
    end

    it "serializes the row_layout" do
      expect(subject[:row_layout]).to eq('halves')
    end

    context "has no widgets" do
      it "serializes an empty widgets array" do
        expect(subject[:widgets]).to be_empty
      end
    end

    context "has widgets" do
      let(:widget_1) { Fabricate(:widget, garden_widget: garden_widget) }
      let(:widget_2) { Fabricate(:widget, garden_widget: other_garden_widget) }
      before do
        cs_widget.set_nested_widget(1, widget_1)
        cs_widget.set_nested_widget(2, widget_2)
        cs_widget.reload
      end
      it "serializes widgets array" do
        expect(subject[:widgets].size).to eq(2)
      end
      it "serializes widgets in correct order" do
        expect(subject[:widgets].first[:slug]).to eq garden_widget.slug
        expect(subject[:widgets].second[:slug]).to eq other_garden_widget.slug
      end
    end

    context "has nested column widgets with widgets" do
    end
  end
end