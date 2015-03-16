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

    describe "#website_defaults" do
      let!(:client) { Fabricate(:client, vertical: vertical) }

      subject { client.website_defaults }

      context "Self Storage" do
        let(:vertical) { "Self-Storage" }

        it "loads the appropriate defaults" do
          expect(subject).to eq load_website_yaml_file("website_defaults_self_storage")
        end
      end

      context "Apartments" do
        let(:vertical) { "Apartments" }

        it "loads the appropriate defaults" do
          expect(subject).to eq load_website_yaml_file("website_defaults_apartments")
        end
      end

      context "Assisted Living" do
        let(:vertical) { "senior-Living" }

        it "loads the appropriate defaults" do
          expect(subject).to eq load_website_yaml_file("website_defaults_senior_living")
        end
      end

      context "everything else" do
        let(:vertical) { "foo" }

        it "loads the appropriate defaults" do
          expect(subject).to eq load_website_yaml_file("defaults")
        end
      end
    end

    describe "#deploy" do
      it "calls StaticWebsiteDeployerJob with urn" do
        ClientDeployerJob.should_receive(:perform).once
        client.deploy
      end
    end

    describe "#async_deploy" do
      it "enqueues StaticWebsiteDeployerJob with urn" do
        user_email = "user@email.com"
        Resque.stub(:enqueue)
        Resque.should_receive(:enqueue).with(ClientDeployerJob, user_email).once
        client.async_deploy(user_email)
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

