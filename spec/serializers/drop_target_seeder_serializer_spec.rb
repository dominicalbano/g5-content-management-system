require 'spec_helper'

describe DropTargetSeederSerializer do
  let!(:client) { Fabricate(:client) }
  let!(:location) { Fabricate(:location) }
  let!(:website) { Fabricate(:website, owner: location) }
  let!(:web_template) { Fabricate(:web_template) }
  let(:drop_target) { Fabricate(:drop_target, web_template: web_template) }
  let(:garden_widget) { Fabricate(:garden_widget) }

  subject { DropTargetSeederSerializer.new(drop_target).as_json(root: false) }

  describe "#as_json" do
    it "serializes the html_id" do
      expect(subject[:html_id]).to eq drop_target.html_id
    end

    context "drop target has widgets" do
      let!(:widget_1) { Fabricate(:widget, garden_widget: garden_widget, drop_target: drop_target) }
      let!(:widget_2) { Fabricate(:widget, garden_widget: garden_widget, drop_target: drop_target) }
      before { drop_target.reload }
      it "serializes the widgets" do
        expect(subject[:widgets].size).to eq(2)
        expect(subject[:widgets].first[:slug]).to eq widget_1.slug
      end
    end

    context "drop target has no widgets" do
      it "serializes an empty array" do
        expect(subject[:widgets]).to be_empty
      end
    end
  end

  describe "#to_yaml_file" do
    ## TODO: write this spec
  end
end