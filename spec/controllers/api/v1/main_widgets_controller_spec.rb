require "spec_helper"

describe Api::V1::MainWidgetsController, :auth_controller, vcr: VCR_OPTIONS do
  let(:widget) { Fabricate(:widget) }
  let!(:garden_widget) { Fabricate(:garden_widget) }

  describe "#show" do
    it "finds widget" do
      Widget.should_receive(:find).with(widget.id.to_s).once
      get :show, id: widget.id
    end

    it "renders widget as json" do
      get :show, id: widget.id
      expect(response.body).to eq WidgetSerializer.new(widget, root: :main_widget).to_json
    end
  end

  describe "#create" do
    context "when create succeeds" do
      before do
        Widget.any_instance.stub(:save) { true }
      end

      it "responds 200 OK" do
        post :create, id: widget.id, main_widget: { name: "lol" }
        expect(response.status).to eq 200
      end

      it "renders widget as json" do
        WidgetSerializer.should_receive(:new).once
        post :create, id: widget.id, main_widget: { name: "lol" }
        expect(response.body).to include "{\"main_widget\":{"
      end
    end

    context "when create fails" do
      before do
        Widget.any_instance.stub(:save) { false }
      end

      it "responds 422 UNPROCESSABLE" do
        post :create, id: widget.id, main_widget: { name: "lol" }
        expect(response.status).to eq 422
      end


      it "renders widget errors as json" do
        post :create, id: widget.id, main_widget: { name: "lol" }
        expect(response.body).to eq "{}"
      end
    end

    context "allowed attributes" do
      it "garden_widget_id" do
        put :update, id: widget.id, main_widget: { garden_widget_id: garden_widget.id }
        expect(response.status).to eq 200
        expect(widget.reload.garden_widget_id).to eq garden_widget.id
      end
    end
  end

  describe "#destroy" do
    context "when destroy succeeds" do
      before do
        Widget.any_instance.stub(:destroy) { true }
      end

      it "responds 200 OK" do
        delete :destroy, id: widget.id
        expect(response.status).to eq 200
      end

      it "renders nil as json" do
        delete :destroy, id: widget.id
        expect(response.body).to eq nil.to_json
      end
    end

    context "when destroy fails" do
      before do
        Widget.any_instance.stub(:destroy) { false }
      end

      it "responds 422 UNPROCESSABLE" do
        delete :destroy, id: widget.id
        expect(response.status).to eq 422
      end


      it "renders widget errors as json" do
        delete :destroy, id: widget.id
        expect(response.body).to eq "{}"
      end
    end
  end
end
