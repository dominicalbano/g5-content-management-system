require "spec_helper"

describe Client do
  describe "validations" do
    it "should have a valid fabricator" do
      Fabricate.build(:client).should be_valid
    end

    it "should require uid" do
      Fabricate.build(:client, uid: "").should_not be_valid
    end

    it "should require name" do
      Fabricate.build(:client, name: "").should_not be_valid
    end

    it "should require type" do
      Fabricate.build(:client, type: "").should_not be_valid
    end
  end


  describe "instance methods" do
    let(:client) {Fabricate(:client)}

    describe "#create_bucket" do
      it "sends self to the bucket creator" do
        client = Fabricate(:client)
        bucket_creator = instance_double(BucketCreator)

        expect(BucketCreator).to receive(:new).with(client).and_return(bucket_creator)
        expect(bucket_creator).to receive(:create)

        client.create_bucket
      end
    end
    
    describe "#bucket_asset_key_prefix" do
      it "returns the urn" do
        expect(client.bucket_asset_key_prefix).to eq(client.urn)
      end
    end
  end
end

