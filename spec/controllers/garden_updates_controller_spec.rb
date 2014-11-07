require 'spec_helper'

describe GardenUpdatesController do
  describe "#update" do
    before do
      ResqueSpec.reset!
      put :update, params
    end

    describe "web layout update" do
      let(:params) { { "id" => "garden_web_layout" } }

      it "enqueues the GardenWebLayoutUpdaterJob" do
        expect(GardenWebLayoutUpdaterJob).to have_queue_size_of(1)
      end
    end

    describe "web theme update" do
      let(:params) { { "id" => "garden_web_theme" } }

      it "enqueues the GardenWebThemeUpdaterJob" do
        expect(GardenWebThemeUpdaterJob).to have_queue_size_of(1)
      end
    end

    describe "widget update" do
      let(:params) { { "id" => "garden_widget" } }

      it "enqueues the GardenWidgetUpdaterJob" do
        expect(GardenWidgetUpdaterJob).to have_queue_size_of(1)
      end
    end
  end
end
