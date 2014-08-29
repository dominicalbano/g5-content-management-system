require "spec_helper"

describe LocationNameManager do
  let(:location) { Fabricate(:location, name: "Foo Bar Baz") }
  let(:location_name_manager) { described_class.new(location.name) }

  describe "#asset_bucket_config_variable_name" do
    subject { location_name_manager.asset_bucket_config_variable_name }

    it { is_expected.to eq("AWS_S3_BUCKET_NAME_FOO_BAR_BAZ") }
  end

  describe "#asset_bucket_name" do
    subject { location_name_manager.asset_bucket_name }

    it { is_expected.to eq("assets.foo-bar-baz") }
  end

  describe "#asset_bucket_config" do
    subject { location_name_manager.asset_bucket_config }

    it { is_expected.to eq("AWS_S3_BUCKET_NAME_FOO_BAR_BAZ=assets.foo-bar-baz") }
  end
end
