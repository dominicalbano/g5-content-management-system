require "spec_helper"

describe ContentStripeWidgetSeederJob do
  let!(:location) { Fabricate(:location) }
  let(:cs_widget_seeder_job) { double(perform: nil) }
  let(:params) { nil }

  describe "#self.perform" do
    before { described_class.stub(new: cs_widget_seeder_job) }
    after { subject }

    subject { described_class.perform(params) }

    context "a location without a website" do
      it "does not instantiate a new job with the content stripe" do
        described_class.should_receive(:new).exactly(0).times
      end

      it "does not seed a content stripe" do
        cs_widget_seeder_job.should_not_receive(:perform)
      end
    end

    context "a location with a website" do
      let!(:website) { Fabricate(:website, owner: location) }
      let!(:web_template) { Fabricate(:web_page_template, website: website) }
      let(:params) { { 'urn' => location.urn, 'slug' => slug } }
      let(:slug) { nil }

      context "with a page matching the slug" do
        let(:slug) { web_template.slug }

        it "instantiates a new job with the content stripe" do
          described_class.should_receive(:new).exactly(1).times
        end

        it "performs content stripe seeder for the content stripe" do
          cs_widget_seeder_job.should_receive(:perform)
        end
      end

      context "when no pages matches the slug" do
        let(:slug) { "fail" }

        it "does not instantiate a new job with the content stripe" do
          described_class.should_receive(:new).exactly(0).times
        end

        it "does not seed a content stripe" do
          cs_widget_seeder_job.should_not_receive(:perform)
        end
      end

      context "when no slug is provided" do
        it "does not instantiate a new job with the content stripe" do
          described_class.should_receive(:new).exactly(0).times
        end

        it "does not seed a content stripe" do
          cs_widget_seeder_job.should_not_receive(:perform)
        end
      end
    end
  end
end
