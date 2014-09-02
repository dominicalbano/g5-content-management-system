require "spec_helper"

describe LocationBucketCreator do
  let!(:client) { Fabricate(:client, name: "Test Client") }
  let(:location) { Fabricate(:location, name: "Foo Bar Baz") }
  let(:location_bucket_creator) { described_class.new(location) }
  let(:s3) { double(buckets: buckets) }
  let(:buckets) { double(create: nil) }

  let(:heroku_client) { double(set_config: nil) }

  before do
    SecureRandom.stub(hex: 12345)
    AWS::S3.stub(new: s3)
    HerokuClient.stub(new: heroku_client)
  end

  describe "#create" do
    subject { location_bucket_creator.create }

    after { subject }

    describe "bucket creation" do
      it "instantiates a new AWS::S3 client" do
        AWS::S3.should_receive(:new)
      end

      it "calls create on the S3 client's buckets" do
        buckets.should_receive(:create).with("assets.foo-bar-baz-12345")
      end
    end

    describe "config set" do
      it "instantiates a new HerokuClient" do
        HerokuClient.should_receive(:new).with(ClientServices.new.cms_app_name)
      end

      it "calls create on the S3 client's buckets" do
        heroku_client.should_receive(:set_config).with("AWS_S3_BUCKET_NAME_FOO_BAR_BAZ", "assets.foo-bar-baz-12345")
      end
    end
  end
end
