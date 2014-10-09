require "spec_helper"

describe S3BucketNameManager do
  let(:location) { Fabricate(:location, name: "Foo Bar Baz", urn: "g5-cl-foo-bar-baz") }
  let!(:client) {Fabricate(:client)}
  let(:s3_bucket_name_manager) { S3BucketNameManager.new(location) }

  before { SecureRandom.stub(hex: 12345) }

  describe "#heroku_config_key_for_bucket_url" do
    subject { s3_bucket_name_manager.heroku_config_key_for_bucket_url }
    it {is_expected.to eq("S3_BUCKET_URL")}
  end

  describe "#heroku_config_key_for_bucket_name" do
    subject {s3_bucket_name_manager.heroku_config_key_for_bucket_name}
    it { is_expected.to eq("S3_BUCKET_NAME") }
  end

  describe "#bucket_asset_key_prefix" do
    subject { s3_bucket_name_manager.bucket_asset_key_prefix }
    it { is_expected.to eq("#{client.urn}/g5-cl-foo-bar-baz") }
  end

  describe "#bucket_config" do
    subject { s3_bucket_name_manager.heroku_bucket_config }
    it { is_expected.to eq("S3_BUCKET_NAME=#{S3BucketNameManager.const_get("BUCKET_NAME")}") }
  end

  describe "#bucket_name" do
    subject { s3_bucket_name_manager.bucket_name }
    it {is_expected.to eq "g5-orion-clients"}
  end

  describe "#bucket_url" do
    subject { s3_bucket_name_manager.bucket_url }
    it { is_expected.to eq(S3BucketNameManager.const_get("BUCKET_URL")) }
  end
end

