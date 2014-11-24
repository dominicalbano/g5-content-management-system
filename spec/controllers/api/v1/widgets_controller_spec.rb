require "spec_helper"

describe Api::V1::WidgetsController, :auth_controller, vcr: VCR_OPTIONS do
  let(:widget) { Fabricate(:widget) }
  let!(:garden_widget) { Fabricate(:garden_widget) }

  controller(Api::V1::WidgetsController) do
  end
  describe "#show" do
    it "finds widget" do
      Widget.should_receive(:find).with(widget.id.to_s).once
      get :show, id: widget.id
    end

    it "renders widget as json" do
      get :show, id: widget.id
      expect(response.body).to eq WidgetSerializer.new(widget, root: :widget).to_json
    end
  end

  describe "#create" do
    context "when create succeeds" do
      before do
        Widget.any_instance.stub(:save) { true }
      end

      it "responds 200 OK" do
        expect(response.status).to eq 200
      end

      it "renders widget as json" do
        WidgetSerializer.should_receive(:new).once
        post :create, id: widget.id, widget: { name: "lol" }
        expect(response.body).to include "{\"widget\":{"
      end

      it "renders widget as json with the drop_target_id" do
        website_template = Fabricate(:website_template)
        drop_target = Fabricate(:drop_target, html_id: "drop-target-widget")
        website_template.drop_targets << drop_target
        post :create, id: widget.id, widget: { website_template_id: website_template.id, name: "lol" }
        expect(response.body).to include "\"drop_target_id\":#{drop_target.id}"
      end
    end

    context "when create fails" do
      before do
        Widget.any_instance.stub(:save) { false }
      end

      it "responds 422 UNPROCESSABLE" do
        post :create, id: widget.id, widget: { name: "lol" }
        expect(response.status).to eq 422
      end


      it "renders widget errors as json" do
        post :create, id: widget.id, widget: { name: "lol" }
        expect(response.body).to eq "{}"
      end
    end

    context "allowed attributes" do
      it "garden_widget_id" do
        put :update, id: widget.id, widget: { garden_widget_id: garden_widget.id }
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
