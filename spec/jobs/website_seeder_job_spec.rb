require "spec_helper"

describe WebsiteSeederJob do
  let!(:location) { Fabricate(:location) }
  let!(:location2) { Fabricate(:location) }
  let!(:location3) { Fabricate(:location) }
  let!(:website) { Fabricate(:website, owner: location) }
  let(:website_seeder_job) { double(perform: nil) }

  describe "#self.perform" do
    before { described_class.stub(new: website_seeder_job) }
    after { subject }

    subject { described_class.perform }

    context "a location without a website" do
      it "instantiates a new job with the locations" do
        described_class.should_receive(:new).exactly(2).times
      end

      it "performs website seeder for the locations" do
        website_seeder_job.should_receive(:perform)
      end
    end

    context "a location with a website" do
      let!(:website2) { Fabricate(:website, owner: location2) }
      let!(:website3) { Fabricate(:website, owner: location3) }

      it "does not instantiate a new job with the locations" do
        described_class.should_receive(:new).exactly(0).times
      end

      it "does not seed a website" do
        website_seeder_job.should_not_receive(:perform)
      end
    end

    context "a location by URN - replace website" do
      let(:location_urn) { location.urn }
      subject { described_class.perform(location_urn) }

      it "instantiates a new job with the location" do
        described_class.should_receive(:new).exactly(1).times
      end

      it "performs website seeder for the location" do
        website_seeder_job.should_receive(:perform)
      end
    end
  end
end
