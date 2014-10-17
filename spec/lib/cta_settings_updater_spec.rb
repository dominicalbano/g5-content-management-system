require "spec_helper"

describe CtaSettingsUpdater do
  let(:cta_settings_updater) { described_class.new }
  let!(:client) { Fabricate(:client, vertical: "fast-food") }
  let!(:location) { Fabricate(:location, city: "Bend", state: "Oregon") }
  let!(:website) { Fabricate(:website, owner: location) }
  let!(:web_template) { Fabricate(:web_page_template, website: website) }
  let!(:drop_target) { Fabricate(:drop_target, web_template: web_template) }
  let!(:widget) { Fabricate(:widget, drop_target: drop_target) }
  let!(:setting) { Fabricate(:setting, name: "foo", owner: widget) }
  let!(:link_setting) { Fabricate(:setting, name: "cta_link_1", owner: widget) }

  before do
    web_template.stub(:update_navigation_settings)
  end  

  describe "#update" do
    subject { cta_settings_updater.update }

    context "a setting value that goes to root" do
      let!(:link_setting) do
        Fabricate(:setting, name: "cta_link_1", value: "/", owner: widget)
      end

      it "does nothing" do
        link_setting.should_not_receive(:update)
        subject
      end
    end

    context "a nil setting value" do
      let!(:link_setting) do
        Fabricate(:setting, name: "cta_link_1", value: nil, owner: widget)
      end

      it "does nothing" do
        link_setting.should_not_receive(:update)
        subject
      end
    end

    context "a valid setting with no website found" do
      let(:website_finder) { double(find: nil) }

      let!(:link_setting) do
        Fabricate(:setting, name: "cta_link_1", value: "/foo/bar/baz", owner: widget)
      end

      before { SettingWebsiteFinder.stub(new: website_finder) }

      it "does nothing" do
        link_setting.should_not_receive(:update)
        subject
      end
    end

    context "a valid setting" do
      let!(:link_setting) do
        Fabricate(:setting, name: "cta_link_1", value: "/foo/bar/baz", owner: widget)
      end

      it "updates the setting value" do
        subject
        expect(link_setting.reload.value).to eq("/fast-food/oregon/bend/baz")
      end
    end
  end

  describe "#cta_link_settings" do
    subject { cta_settings_updater.cta_link_settings }

    it "only returns cta_link settings" do
      expect(subject).to eq([link_setting])
    end
  end
end
