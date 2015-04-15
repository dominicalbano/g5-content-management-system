require "spec_helper"

describe Client do
  def load_yaml(file)
    YAML.load_file("#{Rails.root}/config/#{file}")
  end

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

    describe "#website_defaults" do
      let!(:client) { Fabricate(:client, vertical: vertical) }

      subject { client.website_defaults }

      context "Self Storage" do
        let(:vertical) { "Self-Storage" }

        it "loads the appropriate defaults" do
          expect(subject).to eq load_yaml("website_defaults_self_storage.yml")
        end
      end

      context "Apartments" do
        let(:vertical) { "Apartments" }

        it "loads the appropriate defaults" do
          expect(subject).to eq load_yaml("website_defaults_apartments.yml")
        end
      end

      context "Assisted Living" do
        let(:vertical) { "senior-Living" }

        it "loads the appropriate defaults" do
          expect(subject).to eq load_yaml("website_defaults_senior_living.yml")
        end
      end

      context "everything else" do
        let(:vertical) { "foo" }

        it "loads the appropriate defaults" do
          expect(subject).to eq load_yaml("defaults.yml")
        end
      end
    end

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

