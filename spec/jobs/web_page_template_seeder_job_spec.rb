require "spec_helper"

describe WebPageTemplateSeederJob do
  let!(:location) { Fabricate(:location) }
  let(:web_page_template_seeder_job) { double(perform: nil) }

  describe "#self.perform" do
    before { described_class.stub(new: web_page_template_seeder_job) }
    after { subject }

    subject { described_class.perform(location.urn) }

    context "a location without a website" do
      it "does not instantiate a new job with the web page template" do
        described_class.should_receive(:new).exactly(0).times
      end

      it "does not seed a web page template" do
        web_page_template_seeder_job.should_not_receive(:perform)
      end
    end

    context "a location with a website" do
      let!(:website) { Fabricate(:website, owner: location) }

      it "instantiates a new job with the web page template" do
        described_class.should_receive(:new).exactly(1).times
      end

      it "performs web page template seeder for the web page template" do
        web_page_template_seeder_job.should_receive(:perform)
      end
    end
  end
end
