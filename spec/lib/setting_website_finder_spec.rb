require "spec_helper"

describe SettingWebsiteFinder do
  let(:finder) { described_class.new(setting) }
  let(:widget) { Fabricate(:widget) }
  let(:setting) { Fabricate(:setting, owner: widget) }

  describe "#find" do
    subject { finder.find }

    context "a normal widget setting" do
      it { should be_nil }
    end

    context "a widget within a row or column widget" do
      let!(:client) { Fabricate(:client) }
      let!(:website) { Fabricate(:website) }
      let!(:web_template) { Fabricate(:web_page_template, website: website) }
      let!(:drop_target) { Fabricate(:drop_target, web_template: web_template) }
      let!(:row_widget) { Fabricate(:widget, drop_target: drop_target) }

      let!(:row_widget_setting) do
        Fabricate(:setting, name: "row_one_widget_id", value: widget.id, owner: row_widget)
      end

      context "a widget within a row widget" do
        before { Widget.any_instance.stub(drop_target: drop_target) }

        it { should eq(website) }
      end
    end
  end

  describe "#find_layout_setting_by_value" do
    let!(:setting_one) { Fabricate(:setting, value: 1234, name: "column_one_widget_id") }
    let!(:setting_two) { Fabricate(:setting, value: 123, name: "column_one_widget_id") }

    subject { finder.find_layout_setting_by_value(123) }

    it "finds the correct setting" do
      expect(subject).to eq(setting_two)
    end
  end
end
