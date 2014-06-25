require "spec_helper"

describe WebsiteSeederJob do
  let!(:location) { Fabricate(:location) }
  let(:website_seeder_job) { double(perform: nil) }

  describe "#self.perform" do
    before { described_class.stub(new: website_seeder_job) }
    after { subject }

    subject { described_class.perform }

    context "a location without a website" do
      it "instantiates a new job with the location" do
        described_class.should_receive(:new).with(location)
      end

      it "performs website seeder for the location" do
        website_seeder_job.should_receive(:perform)
      end
    end

    context "a location with a website" do
      before { Fabricate(:website, owner: location) }

      it "does not instantiate a new job with the location" do
        described_class.should_not_receive(:new).with(location)
      end

      it "does not seed a website" do
        website_seeder_job.should_not_receive(:perform)
      end
    end
  end
end
