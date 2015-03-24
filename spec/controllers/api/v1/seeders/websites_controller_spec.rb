require "spec_helper"

describe Api::V1::Seeders::WebsitesController, :auth_controller do
  let!(:client) { Fabricate(:client, vertical: vertical) }
  let!(:location) { Fabricate(:location) }
  let!(:website) { Fabricate(:website, owner: location) }
  let!(:controller) { Api::V1::Seeders::WebsitesController }
  
  let!(:serializer) { WebsiteSeederSerializer }
  let!(:seeder) { WebsiteSeederJob }
  let!(:yaml_files) { ['apartments_luxe_1', 'apartments_luxe_2', 'self_storage_luxe_1', 'senior_living_luxe_1'] }
 
  let(:vertical) { 'apartments' }
  let(:location_slug) { location.name.downcase.gsub(' ','_').underscore }

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
    let!(:file_name) { "#{vertical}_#{location_slug}" }
    subject { post :serialize, id: location.urn }

    before do
      File.stub(:write).and_return(true)
      @response = subject
      @json = JSON.parse(@response.body)
    end

    context "id param matches location's urn" do
      it "returns json data and 200 status" do
        expect(@response.content_type).to eq('application/json')
        expect(@response.status).to eq(200)
      end

      it "returns the seeder file name created by the serializer" do
        expect(@json['yml']).to eq(file_name)
      end
    end

    context "id param does not match any location's urn" do
      subject { post :serialize, id: 'foo' }

      it "returns json data and 422 status" do
        expect(@response.content_type).to eq('application/json')
        expect(@response.status).to eq(422)
      end

      it "returns empty json" do
        expect(@json['yml']).to be_nil
      end
    end
  end

  describe "#seed" do
    let!(:file_name) { "#{vertical}_#{location_slug}" }
    subject { post :seed, id: location.urn, yml: file_name }

    before do
      ResqueSpec.reset!
      @response = subject
      @json = JSON.parse(@response.body)
    end

    context "id param matches location's urn and has valid yml" do
      it "returns json data and 202 status" do
        expect(@response.content_type).to eq('application/json')
        expect(@response.status).to eq(202)
      end

      it "returns json without error" do
        expect(@json['message']).to_not include('ERROR')
      end

      it "enqueues job in Resque" do
        expect(seeder).to have_queue_size_of(1)
      end
    end

    context "id param does not match any location's urn" do
      subject { post :seed, id: 'foo', yml: file_name }

      it "returns json data and 422 status" do
        expect(@response.content_type).to eq('application/json')
        expect(@response.status).to eq(422)
      end

      it "returns json with error" do
        expect(@json['message']).to include('ERROR')
      end

      it "does not enqueue job in Resque" do
        expect(seeder).to have_queue_size_of(0)
      end
    end

    context "yml param is not set" do
      subject { post :seed, id: location.urn }

      it "returns json data and 422 status" do
        expect(@response.content_type).to eq('application/json')
        expect(@response.status).to eq(422)
      end

      it "returns json with error" do
        expect(@json['message']).to include('ERROR')
      end

      it "does not enqueue job in Resque" do
        expect(seeder).to have_queue_size_of(0)
      end
    end
  end
end
