require "spec_helper"

describe Api::V1::WebLayoutsController, :auth_controller, vcr: VCR_OPTIONS do
  let(:web_layout) { Fabricate(:web_layout) }

  describe "#show" do
    it "finds web_layout" do
      WebLayout.should_receive(:find).with(web_layout.id.to_s).once
      get :show, id: web_layout.id
    end

    it "renders web_layout as json" do
      get :show, id: web_layout.id
      expect(response.body).to eq WebLayoutSerializer.new(web_layout).to_json
    end
  end

  describe "#update" do
    context "when update_attributes succeeds" do
      before do
        WebLayout.any_instance.stub(:update_attributes) { true }
      end

      it "responds 200 OK" do
        put :update, id: web_layout.id, web_layout: { name: "lol" }
        expect(response.status).to eq 200
      end

      it "renders web_layout as json" do
        put :update, id: web_layout.id, web_layout: { name: "lol" }
        expect(response.body).to eq WebLayoutSerializer.new(web_layout).to_json
      end
    end

    context "when update_attributes fails" do
      before do
        WebLayout.any_instance.stub(:update_attributes) { false }
      end

      it "responds 422 UNPROCESSABLE" do
        put :update, id: web_layout.id, web_layout: { name: "lol" }
        expect(response.status).to eq 422
      end


      it "renders web_layout errors as json" do
        put :update, id: web_layout.id, web_layout: { name: "lol" }
        expect(response.body).to eq "{}"
      end
    end

    context "allowed attributes" do
      it "garden_web_layout_id" do
        put :update, id: web_layout.id, web_layout: { garden_web_layout_id: 333 }
        expect(response.status).to eq 200
        expect(web_layout.reload.garden_web_layout_id).to eq 333
      end
    end
  end
end
