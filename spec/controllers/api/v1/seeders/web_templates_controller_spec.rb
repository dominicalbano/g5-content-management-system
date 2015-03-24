require "spec_helper"

describe Api::V1::Seeders::WebTemplatesController do #, :auth_controller, vcr: VCR_OPTIONS do
  let!(:location) { Fabricate(:location) }
  let!(:website) { Fabricate(:website, owner: location) }
  let!(:web_template) { Fabricate(:web_page_template, website: website) }

  controller(Api::V1::Seeders::WebTemplatesController) do
  end

  describe "#index" do
    it "finds all website template seeder files" do
      #Widget.should_receive(:find).with(widget.id.to_s).once
      #get :show, id: widget.id
    end

    it "renders website seeder files as json" do
    #  get :show, id: widget.id
    #  expect(response.body).to eq WidgetSerializer.new(widget, root: :widget).to_json
    end
  end

  describe "#show" do
    it "finds web template seeder files matching pattern" do
      #Widget.should_receive(:find).with(widget.id.to_s).once
      #get :show, id: widget.id
    end

    it "renders matching web template seeder file list as json" do
    #  get :show, id: widget.id
    #  expect(response.body).to eq WidgetSerializer.new(widget, root: :widget).to_json
    end
  end

  describe "#serialize" do
    it "finds website by location urn" do
      #Widget.should_receive(:find).with(widget.id.to_s).once
      #get :show, id: widget.id
    end

    it "finds web template on website by slug param" do
    #  get :show, id: widget.id
    #  expect(response.body).to eq WidgetSerializer.new(widget, root: :widget).to_json
    end

    it "serializes the web template into seeder file" do
    end

    it "returns name of seeder file as json" do
    end
  end

  describe "#seed" do
    it "finds the website by location urn" do
      #Widget.should_receive(:find).with(widget.id.to_s).once
      #get :show, id: widget.id
    end

    it "creates a new WebPageTemplateSeederJob for website using seeder file" do
    #  get :show, id: widget.id
    #  expect(response.body).to eq WidgetSerializer.new(widget, root: :widget).to_json
    end
  end
end
