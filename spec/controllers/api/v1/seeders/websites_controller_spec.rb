require "spec_helper"

describe Api::V1::Seeders::WebsitesController do #, :auth_controller, vcr: VCR_OPTIONS do
  let!(:location) { Fabricate(:location) }
  let!(:website) { Fabricate(:website, owner: location) }
  let!(:controller) { Api::V1::Seeders::WebsitesController }
  let!(:serializer) { WebsiteSeederSerializer }
  let!(:seeder) { Seeder::WebsiteSeeder }
  let!(:yaml_files) { ['apartments_luxe_1', 'apartments_luxe_2', 'self_storage_luxe_1', 'senior_living_luxe_1'] }
 
  let(:vertical) { 'apartments' }

  before do
    serializer.any_instance.stub(:get_yaml_files).and_return(yaml_files)
  end

  describe "#index" do
    subject { get :index }
    before do
      @response = subject
      @json = JSON.parse(@response.body)
    end
    
    it "returns json data and 200 status" do
      expect(@response.content_type).to eq('application/json')
      expect(@response.status).to eq(200)
    end

    it "finds all website seeder files" do
      expect(@json.size).to eq(yaml_files.size)
    end
  end

  describe "#show" do
    context "id param matches vertical in files" do
      subject { get :show, id: vertical }
      before do
        @response = subject
        @json = JSON.parse(@response.body)
      end

      it "returns json data and 200 status" do
        expect(@response.content_type).to eq('application/json')
        expect(@response.status).to eq(200)
      end

      it "finds matching website seeder files" do
        expect(@json.size).to eq(yaml_files.select { |f| f.include?(vertical) }.size)
      end
    end

    context "id param does not match any verticals in files" do
      subject { get :show, id: 'foo' }
      before do
        @response = subject
        @json = JSON.parse(@response.body)
      end

      it "returns json data and 200 status" do
        expect(@response.content_type).to eq('application/json')
        expect(@response.status).to eq(200)
      end

      it "finds no matching website seeder files" do
        expect(@json.size).to eq(0)
      end
    end
  end

  describe "#serialize" do
    subject { post :serialize, id: vertical }

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
