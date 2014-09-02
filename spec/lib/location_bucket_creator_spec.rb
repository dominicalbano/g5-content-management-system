require "spec_helper"

describe LocationBucketCreator do
  let(:location) { Fabricate(:location, name: "Foo Bar Baz") }
  let(:location_bucket_creator) { described_class.new(location) }
  let(:s3) { double(buckets: buckets) }
  let(:buckets) { double(create: nil) }

  before do
    SecureRandom.stub(hex: 12345)
    AWS::S3.stub(new: s3)
  end

  describe "#create" do
    subject { location_bucket_creator.create }

    describe "bucket creation" do
      after { subject }

      it "instantiates a new AWS::S3 client" do
        AWS::S3.should_receive(:new)
      end

      it "calls create on the S3 client's buckets" do
        buckets.should_receive(:create).with("assets.foo-bar-baz-12345")
      end
    end
  end
end
