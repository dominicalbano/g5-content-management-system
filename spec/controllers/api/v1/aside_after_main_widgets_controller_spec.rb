require "spec_helper"

describe Api::V1::AsideAfterMainWidgetsController, :auth_controller, vcr: VCR_OPTIONS do
  let(:widget) { Fabricate(:widget) }
  describe "#show" do
    it "renders widget as json" do
      get :show, id: widget.id
      expect(response.body).to eq WidgetSerializer.new(widget, root: :aside_after_main_widget).to_json
    end

    it "renders widget as json with the drop_target_id" do
      website_template = Fabricate(:website_template)
      drop_target = Fabricate(:drop_target, html_id: "drop-target-aside-after-main")
      website_template.drop_targets << drop_target
      post :create, id: widget.id, aside_after_main_widget: { website_template_id: website_template.id, name: "lol", garden_widget_id: widget.garden_widget_id}
      expect(response.body).to include "\"drop_target_id\":#{drop_target.id}"
    end
  end
end

