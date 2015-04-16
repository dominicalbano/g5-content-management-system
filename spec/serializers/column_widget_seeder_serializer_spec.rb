require 'spec_helper'

describe ColumnWidgetSeederSerializer do
  let(:col_garden_widget) { Fabricate(:column_garden_widget) }
  let(:garden_widget) { Fabricate(:garden_widget) }
  let(:other_garden_widget) { Fabricate(:html_garden_widget) }
  let(:column_widget) { Fabricate(:widget, garden_widget: col_garden_widget) }
  
  before do
    column_widget.set_setting('row_count', 'two')
    column_widget.reload
  end

  subject { WidgetSeederSerializer.new(column_widget).as_json(root: false) }

  describe "#as_json" do
    it "serializes the slug" do
      expect(subject[:slug]).to eq col_garden_widget.slug
    end

    it "serializes the row_count" do
      expect(subject[:row_count]).to eq('two')
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
        column_widget.set_child_widget(1, widget_1)
        column_widget.set_child_widget(2, widget_2)
        column_widget.reload
      end
      it "serializes widgets array" do
        expect(subject[:widgets].size).to eq(2)
      end
      it "serializes widgets in correct order" do
        expect(subject[:widgets].first[:slug]).to eq garden_widget.slug
        expect(subject[:widgets].second[:slug]).to eq other_garden_widget.slug
      end
    end
  end
end