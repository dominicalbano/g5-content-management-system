require "spec_helper"

describe Api::V1::Seeders::ContentStripesController, :auth_controller do
  let!(:location) { Fabricate(:location) }
  let!(:website) { Fabricate(:website, owner: location) }
  let!(:web_template) { Fabricate(:web_page_template, website: website) }
  let!(:drop_target) { Fabricate(:drop_target, web_template: web_template, html_id: "drop-target-main") }
  
  let!(:garden_widget) { Fabricate(:garden_widget) }
  let!(:garden_widget2) { Fabricate(:garden_widget) }
  let!(:garden_widget3) { Fabricate(:garden_widget) }
  let!(:widget1) { Fabricate(:widget, garden_widget: garden_widget) }
  let!(:widget2) { Fabricate(:widget, garden_widget: garden_widget2) }
  let!(:widget3) { Fabricate(:widget, garden_widget: garden_widget3) }

  let!(:cs_garden_widget) { Fabricate(:content_stripe_garden_widget) }
  let!(:cs_widget) { Fabricate(:widget, garden_widget: cs_garden_widget, drop_target: drop_target) }
  let!(:cs_widget2) { Fabricate(:widget, garden_widget: cs_garden_widget, drop_target: drop_target) }

  let!(:serializer) { ContentStripeWidgetSeederSerializer }
  let!(:seeder) { ContentStripeWidgetSeederJob }
  let!(:yaml_files) do
   [
    'halves_html_html',
    'halves_html_gallery',
    'uneven_thirds_1_html_html',
    'uneven_thirds_1_html_gallery',
    'uneven_thirds_2_html_gallery',
    'thirds_html_html_html',
    'quarters_html_gallery_html_html'
    ]
  end
 
  let(:layout) { 'halves' }
  let(:layout2) { 'single' }

  before do
    serializer.any_instance.stub(:get_yaml_files).and_return(yaml_files)
    cs_widget.set_setting(cs_widget.layout_var, layout)
    cs_widget.set_child_widget(1, widget1)
    cs_widget.set_child_widget(2, widget2)
    cs_widget2.set_setting(cs_widget2.layout_var, layout2)
    cs_widget2.set_child_widget(1, widget3)
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

    it "finds all content stripe seeder files" do
      expect(@json.size).to eq(yaml_files.size)
    end
  end

  describe "#show" do
    context "id param matches layout in files" do
      subject { get :show, id: layout }
      before do
        @response = subject
        @json = JSON.parse(@response.body)
      end

      it "returns json data and 200 status" do
        expect(@response.content_type).to eq('application/json')
        expect(@response.status).to eq(200)
      end

      it "finds matching content stripe seeder files" do
        expect(@json.size).to eq(yaml_files.select { |f| f.include?(layout) }.size)
      end
    end

    context "id param does not match any layouts in files" do
      subject { get :show, id: 'foo' }
      before do
        @response = subject
        @json = JSON.parse(@response.body)
      end

      it "returns json data and 200 status" do
        expect(@response.content_type).to eq('application/json')
        expect(@response.status).to eq(200)
      end

      it "finds no matching content stripe seeder files" do
        expect(@json.size).to eq(0)
      end
    end
  end

  describe "#serialize" do
    let!(:file_name1) { "#{layout}_#{widget1.slug}_#{widget2.slug}".underscore }
    let!(:file_name2) { "single_#{widget3.slug}".underscore }
    
    before do
      File.stub(:write).and_return(true)
      @response = subject
      @json = JSON.parse(@response.body)
    end

    context "by id" do
      context "widget is content stripe" do
        subject { post :serialize, id: cs_widget.id }

        it "returns json data and 200 status" do
          expect(@response.content_type).to eq('application/json')
          expect(@response.status).to eq(200)
        end

        it "returns the seeder file name created by the serializer" do
          expect(@json['yml']).to eq(file_name1)
        end
      end

      context "widget is not content stripe" do
        subject { post :serialize, id: widget1.id }

        it "returns json data and 422 status" do
          expect(@response.content_type).to eq('application/json')
          expect(@response.status).to eq(422)
        end

        it "returns empty json" do
          expect(@json['yml']).to be_nil
        end
      end
    end

    context "by urn, slug and index" do
      context "widget is content stripe" do
        context "by index" do
          subject { post :serialize, id: location.urn, slug: web_template.slug }

          it "returns json data and 200 status" do
            expect(@response.content_type).to eq('application/json')
            expect(@response.status).to eq(200)
          end

          it "returns the seeder file name created by the serializer for the first content stripe on the web template" do
            expect(@json['yml']).to eq(file_name1)
          end
        end

        context "by no index" do
          subject { post :serialize, id: location.urn, slug: web_template.slug, index: 2 }

          it "returns json data and 200 status" do
            expect(@response.content_type).to eq('application/json')
            expect(@response.status).to eq(200)
          end

          it "returns the seeder file name created by the serializer for the content stripe on the web template at position == index" do
            expect(@json['yml']).to eq(file_name2)
          end
        end
      end

      context "widget is not content stripe" do
        context "invalid location urn" do
          subject { post :serialize, id: 'foo', slug: web_template.slug }

          it "returns json data and 422 status" do
            expect(@response.content_type).to eq('application/json')
            expect(@response.status).to eq(422)
          end

          it "returns empty json" do
            expect(@json['yml']).to be_nil
          end
        end

        context "invalid web template slug" do
          subject { post :serialize, id: location.urn, slug: 'foo' }

          it "returns json data and 422 status" do
            expect(@response.content_type).to eq('application/json')
            expect(@response.status).to eq(422)
          end

          it "returns empty json" do
            expect(@json['yml']).to be_nil
          end
        end

        context "invalid index" do
          subject { post :serialize, id: location.urn, slug: web_template.slug, index: 99 }

          it "returns json data and 422 status" do
            expect(@response.content_type).to eq('application/json')
            expect(@response.status).to eq(422)
          end

          it "returns empty json" do
            expect(@json['yml']).to be_nil
          end
        end
      end
    end
  end

  describe "#seed" do
    let!(:file_name) { yaml_files.first }
    subject { post :seed, id: location.urn, slug: web_template.slug, yml: file_name }

    before do
      ResqueSpec.reset!
      @response = subject
      @json = JSON.parse(@response.body)
    end

    context "id param matches location's urn, slug param matches web template, and has valid yml" do
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

    context "slug param does not match any web template param for the location" do
      subject { post :seed, id: 'foo', slug: web_template.slug, yml: file_name }

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
      subject { post :seed, id: location.urn, slug: web_template.slug, yml: nil }

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
