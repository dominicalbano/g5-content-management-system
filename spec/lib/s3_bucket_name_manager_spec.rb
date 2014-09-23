require "spec_helper"

describe S3BucketNameManager do
  let(:location) { Fabricate(:location, name: "Foo Bar Baz", urn: "g5-cl-foo-bar-baz") }
  let(:s3_bucket_name_manager) { described_class.new(location) }

  before { SecureRandom.stub(hex: 12345) }

  describe "#bucket_config_variable_name" do
    subject { s3_bucket_name_manager.bucket_config_variable_name }

    it { is_expected.to eq("AWS_S3_BUCKET_NAME_G5_CL_FOO_BAR_BAZ") }
  end

  describe "#asset_bucket_config_variable_url" do
    subject { s3_bucket_name_manager.bucket_config_variable_url }

    it { is_expected.to eq("AWS_S3_BUCKET_URL_G5_CL_FOO_BAR_BAZ") }
  end

  describe "#bucket_name" do
    subject { s3_bucket_name_manager.bucket_name }

    it { is_expected.to eq("assets.g5-cl-foo-bar-baz") }
  end

  describe "#bucket_config" do
    subject { s3_bucket_name_manager.bucket_config }

    it { is_expected.to eq("AWS_S3_BUCKET_NAME_G5_CL_FOO_BAR_BAZ=assets.g5-cl-foo-bar-baz") }
  end

  describe "#bucket" do
    before { stub_const("ENV", { "AWS_S3_BUCKET_NAME_FOO_BAR_BAZ" => "assets.foo-bar-baz" }) }

    subject { s3_bucket_name_manager.bucket }

    it { is_expected.to eq("assets.g5-cl-foo-bar-baz") }
  end
end
