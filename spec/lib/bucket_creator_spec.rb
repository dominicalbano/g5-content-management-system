require "spec_helper"

describe BucketCreator do
  let!(:client) { Fabricate(:client, name: "Test Client") }
  let(:location) { Fabricate(:location, name: "Foo Bar Baz", urn: "g5-cl-foo") }
  let(:bucket_creator) { BucketCreator.new(location) }
  let(:s3) { double(buckets: buckets) }
  let(:buckets) { double(create: nil) }
  let(:heroku_client) { double(set_config: nil, get_config_vars: config_vars_response) }
  let(:config_vars_response) { "{}" }

  before do
    SecureRandom.stub(hex: 12345)
    AWS::S3.stub(new: s3)
    HerokuClient.stub(new: heroku_client)
  end

  describe "#create" do
    after { bucket_creator.create }

    it "calls get_config_vars on HerokuClient" do
      heroku_client.should_receive(:get_config_vars)
    end

    context "No bucket config var set" do
      context "when the bucket already exists" do
        before do
          allow(buckets).to receive(:create).and_raise(AWS::S3::Errors::BucketAlreadyExists)
        end

        it "doesn't blow up" do
          expect(bucket_creator.create).to eq(false)
        end
      end

      context "when the bucket does not exist" do
        describe "bucket creation" do
          it "instantiates a new AWS::S3 client" do
            AWS::S3.should_receive(:new)
          end

          it "calls create on the S3 client's buckets" do
            buckets.should_receive(:create).with("g5-orion-clients")
          end
        end

        describe "config set" do
          it "instantiates a new HerokuClient" do
            HerokuClient.should_receive(:new).with(ClientServices.new.cms_app_name)
          end

          it "sets the config via the HerokuClient" do
            heroku_client.should_receive(:set_config).
              with("S3_BUCKET_NAME", "g5-orion-clients")
          end
        end
      end
    end
  end
end

