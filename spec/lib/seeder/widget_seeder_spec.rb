require "spec_helper"

##TODO: finish this up!!

describe Seeder::WidgetSeeder do
  let(:drop_target) { Fabricate(:drop_target) }
  let(:defaults) { HashWithIndifferentAccess.new(YAML.load_file("#{Rails.root}/config/defaults/websites/defaults.yml")) }
  let(:instructions) { {slug: 'html'} }
  let(:seeder) { Seeder::WidgetSeeder.new(drop_target, instructions) }
  let!(:html_widget) { Fabricate(:garden_widget, name: "HTML") }
  let!(:content_stripe_widget) { Fabricate(:garden_widget, name: "Content Stripe") }
  let!(:column_widget) { Fabricate(:garden_widget, name: "Column") }

  describe "#seed" do
    context "non-layout widget" do
      
      subject { seeder.seed }

      context "valid instructions - no settings, has drop target" do
        before { @response = subject }

        it "creates a widget in the drop target" do
          expect(drop_target.widgets.first.slug).to eq(html_widget.slug)
          except(@response.drop_target).to_not be_nil
        end
      end

      context "valid instructions - no settings, no drop target" do
        let(:drop_target) { nil }
        before { @response = subject }

        it "creates a stand-alone widget - no drop target" do
          expect(@response.slug).to eq(html_widget.slug)
          except(@response.drop_target).to be_nil
        end
      end

      context "valid instructions - has settings, has drop target" do
      end

      context "valid instructions - has settings, no drop target" do
      end
    end

    context "content stripe widget" do
    end

    context "column widget" do
    end

    context "no instructions" do
      let(:instructions) { nil }
      before { @response = subject }
      it "logs error and returns nil" do
        expect(@response).to be_nil
      end
    end

    context "invalid instructions" do
      before do
        instructions.except!(:slug)
        @response = subject
      end
      it "logs error and returns nil" do
        expect(@response).to be_nil
      end
    end
  end
end