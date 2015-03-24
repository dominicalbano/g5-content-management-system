require "spec_helper"

describe Api::V1::Seeders::WebsiteController do #, :auth_controller, vcr: VCR_OPTIONS do
  controller(Api::V1::Seeders::WebsiteController) do
  end

  describe "#index" do
    it "finds all website seeder files" do
      #Widget.should_receive(:find).with(widget.id.to_s).once
      #get :show, id: widget.id
    end

    it "renders website seeder file list as json" do
    #  get :show, id: widget.id
    #  expect(response.body).to eq WidgetSerializer.new(widget, root: :widget).to_json
    end
  end

  describe "#show" do
    it "finds website seeder files matching pattern" do
      #Widget.should_receive(:find).with(widget.id.to_s).once
      #get :show, id: widget.id
    end

    it "renders matching website seeder file list as json" do
    #  get :show, id: widget.id
    #  expect(response.body).to eq WidgetSerializer.new(widget, root: :widget).to_json
    end
  end

  describe "#serialize" do
    it "finds website by location urn" do
      #Widget.should_receive(:find).with(widget.id.to_s).once
      #get :show, id: widget.id
    end

    it "serializes website into seeder file" do
    #  get :show, id: widget.id
    #  expect(response.body).to eq WidgetSerializer.new(widget, root: :widget).to_json
    end

    it "returns name of seeder file as json" do
    end
  end

  describe "#seed" do
    it "finds the location by location urn" do
      #Widget.should_receive(:find).with(widget.id.to_s).once
      #get :show, id: widget.id
    end

    it "creates a new WebsiteSeederJob for location using seeder file" do
    #  get :show, id: widget.id
    #  expect(response.body).to eq WidgetSerializer.new(widget, root: :widget).to_json
    end
  end
end
