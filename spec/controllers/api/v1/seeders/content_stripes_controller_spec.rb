require "spec_helper"

describe Api::V1::Seeders::ContentStripesController do #, :auth_controller, vcr: VCR_OPTIONS do
  let!(:location) { Fabricate(:location) }
  let!(:website) { Fabricate(:website, owner: location) }
  let!(:web_template) { Fabricate(:web_page_template, website: website) }
  let!(:drop_target) { Fabricate(:drop_target, web_template: web_template, html_id: "drop-target-main") }
  let!(:cs_garden_widget) { Fabricate(:content_stripe_garden_widget) }
  let!(:cs_widget) { Fabricate(:widget, garden_widget: cs_garden_widget, drop_target: drop_target) }

  controller(Api::V1::Seeders::ContentStripesController) do
  end

  describe "#index" do
    subject { get :index }

    it "finds all content stripe template seeder files" do
      #Widget.should_receive(:find).with(widget.id.to_s).once
      #get :show, id: widget.id
    end

    it "renders content stripe seeder files as json" do
    #  get :show, id: widget.id
    #  expect(response.body).to eq WidgetSerializer.new(widget, root: :widget).to_json
    end
  end

  describe "#show" do
    subject { get :show, id: 'halves' }

    it "finds content stripe seeder files matching pattern" do
      #Widget.should_receive(:find).with(widget.id.to_s).once
      #get :show, id: widget.id
    end

    it "renders matching content stripe seeder file list as json" do
    #  get :show, id: widget.id
    #  expect(response.body).to eq WidgetSerializer.new(widget, root: :widget).to_json
    end
  end

  describe "#serialize" do
    context "by id" do
      subject { post :serialize, id: cs_widget }

      it "finds content stripe by widget id" do
        #Widget.should_receive(:find).with(widget.id.to_s).once
        #get :show, id: widget.id
      end

      it "returns nil if widget is not a content stripe" do
      #  get :show, id: widget.id
      #  expect(response.body).to eq WidgetSerializer.new(widget, root: :widget).to_json
      end
    end

    context "by slug and index" do
      it "finds website by location urn" do
        #Widget.should_receive(:find).with(widget.id.to_s).once
        #get :show, id: widget.id
      end

      it "finds web template on website by slug param" do
      #  get :show, id: widget.id
      #  expect(response.body).to eq WidgetSerializer.new(widget, root: :widget).to_json
      end

      it "finds content stripe by index on web template" do
      end

      it "returns nil if widget is not a content stripe" do
      #  get :show, id: widget.id
      #  expect(response.body).to eq WidgetSerializer.new(widget, root: :widget).to_json
      end
    end
    

    it "serializes the content stripe into seeder file" do
    end

    it "returns name of seeder file as json" do
    end
  end

  describe "#seed" do
    it "finds website by location urn" do
      #Widget.should_receive(:find).with(widget.id.to_s).once
      #get :show, id: widget.id
    end

    it "finds web template on website by slug param" do
    #  get :show, id: widget.id
    #  expect(response.body).to eq WidgetSerializer.new(widget, root: :widget).to_json
    end

    it "creates a new ContentStripeSeederJob for web template using seeder file" do
    #  get :show, id: widget.id
    #  expect(response.body).to eq WidgetSerializer.new(widget, root: :widget).to_json
    end
  end
end
