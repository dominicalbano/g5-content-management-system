require "spec_helper"

describe CorporateNavigationSetting do
  let(:nav_setting) { described_class.new }

  let!(:location) { Fabricate(:location) }
  let!(:website) { Fabricate(:website, owner: location) }
  let!(:setting) do
    Fabricate(:setting, name: "navigation", owner: website, value: { foo: "bar" })
  end

  describe "#setting" do
    subject { nav_setting.setting }

    context "no corporate location" do
      it { is_expected.to be_nil }
    end

    context "an existing corporate location" do
      let!(:location) { Fabricate(:location, corporate: true) }

      it { is_expected.to eq(setting) }
    end
  end

  describe "#value" do
    subject { nav_setting.value }

    context "no corporate location" do
      it { is_expected.to be_nil }
    end

    context "an existing corporate location" do
      let!(:location) { Fabricate(:location, corporate: true) }

      it { is_expected.to eq(setting.value) }
    end
  end
end
