require "spec_helper"

describe WebsiteFinder::Base do
  let(:object) { double }
  let(:base_finder) { described_class.new(object) }

  describe "#layout_setting_for" do
    let!(:setting_one) { Fabricate(:setting, value: 1234, name: "column_1_widget_id") }
    let!(:setting_two) { Fabricate(:setting, value: 123, name: "column_1_widget_id") }

    subject { base_finder.layout_setting_for(123) }

    it "finds the correct setting" do
      expect(subject).to eq(setting_two)
    end
  end
end
