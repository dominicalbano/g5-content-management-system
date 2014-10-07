require 'spec_helper'

describe ClientReaderJob, vcr: VCR_OPTIONS do

  describe "#perform" do
    let(:client_uid) { "spec/support/client.html" }
    let(:other_client_uid) { "spec/support/other_client.html" }
    let(:perform) { ClientReaderJob.perform(client_uid) }

    before do
      Client.destroy_all
      Location.destroy_all
    end

    describe "creates clients" do
      it "creates 1 client" do
        expect { perform }.to change(Client, :count).by(1)
        Client.first.uid.should eq client_uid
        Client.all.length.should eq 1
      end
    end

    describe "cleans up clients" do
      before do
        @client = Fabricate(:client, uid: other_client_uid)
        perform
      end

      it "creates 0 new clients" do
        expect { perform }.to change(Client, :count).by(0)
        Client.all.length.should eq 1
      end

      it "saves client with a uid equal to the client_uid passed in" do
        Client.first.uid.should eq client_uid
      end
    end

    describe "creates locations" do
      it "creates 2 locations" do
        expect { perform }.to change(Location, :count).by(2)
        Location.all.length.should eq 2
      end
    end

    describe "cleans up locations" do
      before do
        @location = Fabricate(:location)
        @location2 = Fabricate(:location)
        @location3 = Fabricate(:location)
        perform
      end

      it "removes unrelated locations and creates 2 locations" do
        Location.all.length.should eq 2
      end
    end
  end
end
