require 'spec_helper'

describe GardenUpdatesController do
  describe "#update" do
    let(:params) { { "id" => "garden_web_layout" } }
    let(:token) { double('token') }
    let(:valid) { false }

    before do
      G5AuthenticatableApi::TokenValidator.any_instance.stub(
          access_token: token, valid?: valid
      )
      ResqueSpec.reset!
      put :update, params
    end

    context "without auth_token" do
      let(:token) {}

      it "should be redirected" do
        expect(response.code).to eq('302')
      end
    end

    context "with invalid auth_token" do
      it "should return 401" do
        expect(response.code).to eq('401')
      end
    end

    context "with valid auth_token" do
      let(:valid) { true }

      describe "web layout update" do
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
end
