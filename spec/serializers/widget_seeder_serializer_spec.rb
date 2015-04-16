require "spec_helper"

describe WidgetSeederSerializer do
  describe "#as_json" do
    context "default widget seeder" do
      let(:garden_widget) { Fabricate(:garden_widget) }
      let(:widget) { Fabricate(:widget, garden_widget: garden_widget) }
      let(:serializer) { WidgetSeederSerializer.new(widget) }
      it "serializes the slug" do
        expect(serializer.as_json[:slug]).to eq(garden_widget.slug)
      end
    end
  end
end