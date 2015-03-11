require "spec_helper"

##TODO: finish this up!!

describe Seeder::WidgetSeeder do
  let(:drop_target) { Fabricate(:drop_target) }
  let(:seeder) { Seeder::WidgetSeeder.new(drop_target, instructions) }
  let!(:html_widget) { Fabricate(:html_garden_widget) }
  let!(:content_stripe_widget) { Fabricate(:row_garden_widget) }
  let!(:column_widget) { Fabricate(:column_garden_widget) }

  describe "#seed" do
    context "non-layout widget" do
      let(:instructions) { { slug: 'html' } }
      subject { seeder.seed }

      context "valid instructions - no settings, has drop target" do
        before { @response = subject }

        it "creates a widget in the drop target" do
          expect(drop_target.widgets.first.slug).to eq(html_widget.slug)
          expect(@response.drop_target).to_not be_nil
        end
      end

      context "valid instructions - no settings, no drop target" do
        let(:drop_target) { nil }
        before { @response = subject }

        it "creates a stand-alone widget - no drop target" do
          expect(@response.slug).to eq(html_widget.slug)
          expect(@response.drop_target).to be_nil
        end
      end

      context "valid instructions - has settings, has drop target" do
      end

      context "valid instructions - has settings, no drop target" do
      end
    end

    context "content stripe widget" do
      let(:instructions) { { slug: 'content-stripe' } }
      subject { seeder.seed }
    end

    context "column widget" do
      let(:instructions) { { slug: 'column' } }
      subject { seeder.seed }
    end

    context "no instructions" do
      let(:instructions) { nil }
      subject { seeder.seed }
      before { @response = subject }
      it "logs error and returns nil" do
        expect(@response).to be_nil
      end
    end

    context "invalid instructions" do
      let(:instructions) { { wrong: true } }
      subject { seeder.seed }
      before { @response = subject }
      it "logs error and returns nil" do
        expect(@response).to be_nil
      end
    end
  end
end