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

    describe "status" do
      it "should require status" do
        Fabricate.build(:location, status: "").should_not be_valid
      end

      it "rejects invalid status types" do
        Fabricate.build(:location, status: "Foo").should_not be_valid
      end

      it "accepts Pending status type" do
        Fabricate.build(:location, status: "Pending").should be_valid
      end

      it "accepts Live status type" do
        Fabricate.build(:location, status: "Live").should be_valid
      end

      it "accepts Suspended status type" do
        Fabricate.build(:location, status: "Suspended").should be_valid
      end
    end
  end

  describe "scopes" do
    let!(:live_location) { Fabricate(:location, status: "Live") }
    let!(:corp_location) { Fabricate(:location, status: "Pending", corporate: true) }
    let!(:live_website) { Fabricate(:website, owner: live_location) }

    describe "#default_scope" do
      subject { Location.all }

      it { is_expected.to eq([corp_location, live_location]) }
    end

    describe "#corporate" do
      subject { Location.corporate }

      it { is_expected.to eq(corp_location) }
    end

    describe "#live" do
      subject { Location.live }

      it { is_expected.to eq([live_location]) }
    end

    describe "#live_websites" do
      subject { Location.live_websites }

      it { is_expected.to eq([live_website]) }
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

  describe "#website_defaults" do
    let!(:client) { Fabricate(:client, vertical: vertical) }
    let!(:location) { Fabricate(:location, corporate: corporate) }

    subject { location.website_defaults }

    context "Corporate" do
      let(:corporate) { true }
      context "Self Storage" do
        let(:vertical) { "Self-Storage" }

        it "loads the appropriate defaults" do
          expect(subject).to eq load_website_yaml_file("self_storage_corp_defaults")
        end
      end

      context "Apartments" do
        let(:vertical) { "Apartments" }

        it "loads the appropriate defaults" do
          expect(subject).to eq load_website_yaml_file("apartments_corp_defaults")
        end
      end

      context "Senior Living" do
        let(:vertical) { "senior-Living" }

        it "loads the appropriate defaults" do
          expect(subject).to eq load_website_yaml_file("senior_living_corp_defaults")
        end
      end

      context "everything else" do
        let(:vertical) { "foo" }

        it "loads the appropriate defaults" do
          expect(subject).to eq load_website_yaml_file("defaults")
        end
      end
    end

    context "Non-Corporate" do
      let(:corporate) { false }
      context "Self Storage" do
        let(:vertical) { "Self-Storage" }

        it "loads the appropriate defaults" do
          expect(subject).to eq load_website_yaml_file("self_storage_defaults")
        end
      end

      context "Apartments" do
        let(:vertical) { "Apartments" }

        it "loads the appropriate defaults" do
          expect(subject).to eq load_website_yaml_file("apartments_defaults")
        end
      end

      context "Senior Living" do
        let(:vertical) { "senior-Living" }

        it "loads the appropriate defaults" do
          expect(subject).to eq load_website_yaml_file("senior_living_defaults")
        end
      end

      context "everything else" do
        let(:vertical) { "foo" }

        it "loads the appropriate defaults" do
          expect(subject).to eq load_website_yaml_file("defaults")
        end
      end
    end
  end
end

