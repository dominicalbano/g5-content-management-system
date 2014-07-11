require "spec_helper"

describe Api::V1::WebHomeTemplatesController, :auth_controller do
  let!(:client) { Fabricate(:client) }
  let(:web_home_template) { Fabricate(:web_home_template) }
  let(:main_drop_target) { Fabricate(:drop_target) }

  before do
    web_home_template.drop_targets << main_drop_target
  end

  describe "#index" do
    before do
      WebHomeTemplateSerializer.new(web_home_template)
    end

    it "renders websites as json" do
      get :index
      expect(response.status).to eq 200
      skip("response.body JSON equals WebHomeTemplate.all (after ran through the serializer and as JSON)")
    end
  end

  describe "#show" do
    it "finds web home template" do
      WebHomeTemplate.should_receive(:find).with(web_home_template.id.to_s).once
      get :show, id: web_home_template.id
    end

    it "renders web home template as json" do
      get :show, id: web_home_template.id
      expect(response.body).to eq WebHomeTemplateSerializer.new(web_home_template).to_json
    end
  end

  describe "#update" do
    context "when update_attributes succeeds" do
      before do
        WebHomeTemplate.any_instance.stub(:update_attributes) { true }
      end

      it "responds 200 OK" do
        put :update, id: web_home_template.id, web_home_template: { name: "name" }
        expect(response.status).to eq 200
      end

      it "renders web_home_template as json" do
        put :update, id: web_home_template.id, web_home_template: { name: "name" }
        expect(response.body).to eq WebHomeTemplateSerializer.new(web_home_template).to_json
      end
    end

    context "when update_attributes fails" do
      before do
        WebHomeTemplate.any_instance.stub(:update_attributes) { false }
      end

      it "responds 422 UNPROCESSABLE" do
        put :update, id: web_home_template.id, web_home_template: { name: "name" }
        expect(response.status).to eq 422
      end


      it "renders web_home_template errors as json" do
        put :update, id: web_home_template.id, web_home_template: { name: "name" }
        expect(response.body).to eq "{}"
      end
    end

    context "allowed attributes" do
     it "name" do
        put :update, id: web_home_template.id, web_home_template: { name: "name" }
        expect(response.status).to eq 200
        expect(web_home_template.reload.read_attribute(:name)).to eq "name"
      end

      it "title" do
        put :update, id: web_home_template.id, web_home_template: { title: "title" }
        expect(response.status).to eq 200
        expect(web_home_template.reload.read_attribute(:title)).to eq "title"
      end

      it "enabled" do
        put :update, id: web_home_template.id, web_home_template: { enabled: true }
        expect(response.status).to eq 200
        expect(web_home_template.reload.read_attribute(:enabled)).to eq true
      end
    end
  end
end
