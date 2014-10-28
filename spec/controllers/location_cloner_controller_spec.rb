require 'spec_helper'

describe LocationClonerController do
  let!(:location) { Fabricate(:location) }

  it_should_behave_like 'a secure controller'

  context "with an authenticated user", :auth_controller do
    describe "#index" do
      it "index action should render index template" do
        get :index
        response.should render_template(:index)
      end
    end

    describe "#clone_location" do
      before do
        ResqueSpec.reset!
        request.env["HTTP_REFERER"] = "/location_cloner"
      end

      context "one target id" do
        let(:params) { { "source_location" => "1", "target_location_ids" => ["2"] } }

        it "enqueues a cloner job for each target id" do
          post :clone_location, params
          expect(LocationClonerJob).to have_queued("1", "2").in(:cloner)
        end
      end

      context "multiple target ids" do
        let(:params) { { "source_location" => "1", "target_location_ids" => ["2", "3"] } }

        it "enqueues a cloner job for each target id" do
          post :clone_location, params
          expect(LocationClonerJob).to have_queue_size_of(2)
        end
      end
    end
  end
end
