require "spec_helper"

describe Api::V1::WebPageTemplatesController, :auth_controller do
  let!(:client) { Fabricate(:client) }
  let!(:website) { Fabricate(:website) }
  let(:web_page_template) { Fabricate(:web_page_template, website: website) }
  let(:main_drop_target) { Fabricate(:drop_target) }

  before do
    web_page_template.drop_targets << main_drop_target
  end

  describe "#index" do
    before do
      WebPageTemplateSerializer.new(web_page_template)
    end

    it "renders websites as json" do
      get :index
      expect(response.status).to eq 200
      skip("response.body JSON equals WebPageTemplate.all (after ran through the serializer and as JSON)")
    end
  end

  describe "#show" do
    it "finds web page template" do
      WebPageTemplate.should_receive(:find).with(web_page_template.id.to_s).once
      get :show, id: web_page_template.id
    end

    it "renders web page template as json" do
      get :show, id: web_page_template.id
      expect(response.body).to eq WebPageTemplateSerializer.new(web_page_template).to_json
    end
  end

  describe "#create" do
    context "when create succeeds" do
      it "responds 200 OK" do
        post :create, web_page_template: { name: "name" }
        expect(response.status).to eq 200
      end

      it "renders web_page_template as json" do
        WebPageTemplateSerializer.should_receive(:new).once
        post :create, web_page_template: { name: "WebPageTemplate1" }
        expect(response.body).to include "WebPageTemplate1"
      end
    end

    context "when create fails" do
      before do
        WebPageTemplate.any_instance.stub(:save) { false }
      end

      it "responds 422 UNPROCESSABLE" do
        post :create, web_page_template: { name: "name" }
        expect(response.status).to eq 422
      end


      it "renders web_page_template errors as json" do
        post :create, web_page_template: { name: "name" }
        expect(response.body).to eq "{}"
      end
    end
  end

  describe "#update" do
    context "when update_attributes succeeds" do
      before do
        WebPageTemplate.any_instance.stub(:update_attributes) { true }
      end

      it "responds 200 OK" do
        put :update, id: web_page_template.id, web_page_template: { name: "name" }
        expect(response.status).to eq 200
      end

      it "renders web_page_template as json" do
        put :update, id: web_page_template.id, web_page_template: { name: "name" }
        expect(response.body).to eq WebPageTemplateSerializer.new(web_page_template).to_json
      end
    end

    context "when update_attributes fails" do
      before do
        WebPageTemplate.any_instance.stub(:update_attributes) { false }
      end

      it "responds 422 UNPROCESSABLE" do
        put :update, id: web_page_template.id, web_page_template: { name: "name" }
        expect(response.status).to eq 422
      end

      it "renders web_page_template errors as json" do
        put :update, id: web_page_template.id, web_page_template: { name: "name" }
        expect(response.body).to eq "{}"
      end
    end

    context "allowed attributes" do
      it "name" do
        put :update, id: web_page_template.id, web_page_template: { name: "name" }
        expect(response.status).to eq 200
        expect(web_page_template.reload.read_attribute(:name)).to eq "name"
      end

      it "title" do
        put :update, id: web_page_template.id, web_page_template: { title: "title" }
        expect(response.status).to eq 200
        expect(web_page_template.reload.read_attribute(:title)).to eq "title"
      end

      it "enabled" do
        put :update, id: web_page_template.id, web_page_template: { enabled: true }
        expect(response.status).to eq 200
        expect(web_page_template.reload.read_attribute(:enabled)).to eq true
      end
    end
  end
end
