require "spec_helper"

describe Location do
  describe "validations" do
    it "should have a valid fabricator" do
      Fabricate.build(:location).should be_valid
    end
    it "should require uid" do
      Fabricate.build(:location, uid: "").should_not be_valid
    end
    it "should require name" do
      Fabricate.build(:location, name: "").should_not be_valid
    end
    it "should require urn" do
      Fabricate.build(:location, urn: "").should_not be_valid
    end
  end

  describe "#urn" do
    let(:location) { Fabricate(:location) }

    it "sets on create" do
      location.urn.should match /g5-cl-\d+-/
    end
  end
  describe "#bucket_asset_key_prefix" do
    let(:location) { Fabricate(:location) }
    let!(:client) {Fabricate(:client)}

    it "prepends its urn with the client prefix" do
      expect(location.bucket_asset_key_prefix).to eq("#{client.bucket_asset_key_prefix}/#{location.urn}")
    end
  end

  describe "#website_id" do
    let(:location) { Fabricate(:location) }

    it "if no website then return nil" do
      location.website = nil
      location.website_id.should be_nil
    end

    it "if website then return website's id" do
      website = Fabricate(:website)
      location.website = website
      location.website_id.should eq website.id
    end
  end

  describe "#neighborhood_slug" do
    let(:location) { Fabricate(:location) }

    subject { location.neighborhood_slug }

    context "with no neighborhood" do
      it "doesn't blow up" do
        expect(subject).to be_blank
      end
    end

    context "with a neighborhood" do
      let(:location) { Fabricate(:location, neighborhood: "Some Place") }

      it "parameterizes it" do
        expect(subject).to eq("some-place")
      end
    end
  end

  describe "#create_bucket" do
    let(:location) { Fabricate(:location) }
    let(:location_bucket_creator) { double(create: nil) }

    before { BucketCreator.stub(new: location_bucket_creator) }
    after { location.create_bucket }

    it "instantiates a new BucketCreator class" do
      BucketCreator.should_receive(:new).with(location)
    end

    it "calls create on the bucket creator" do
      location_bucket_creator.should_receive(:create)
    end
  end
end

