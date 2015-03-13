require "spec_helper"

##TODO: finish this up!!

describe Seeder::ColumnWidgetSeeder do
  let(:drop_target) { Fabricate(:drop_target) }
  let(:seeder) { Seeder::WidgetSeeder.new(drop_target, instructions) }
  let!(:html_widget) { Fabricate(:html_garden_widget) }
  let!(:content_stripe_widget) { Fabricate(:row_garden_widget) }
  let!(:column_widget) { Fabricate(:column_garden_widget) }

  describe "#seed" do
    context "non-layout widget" do
      let(:instructions) { { slug: 'html' } }
      subject { seeder.seed }

      context "valid instructions - no settings, has drop target" do
        before { @response = subject }

        it "creates a widget in the drop target" do
          expect(drop_target.widgets.first.slug).to eq(html_widget.slug)
          expect(@response.drop_target).to_not be_nil
          expect(@response.settings).to be_empty
        end
      end

      context "valid instructions - no settings, no drop target" do
        let(:drop_target) { nil }
        before { @response = subject }

        it "creates a stand-alone widget - no drop target" do
          expect(@response.slug).to eq(html_widget.slug)
          expect(@response.drop_target).to be_nil
          expect(@response.settings).to be_empty
        end
      end

      context "valid instructions - has settings, has drop target" do
        let(:instructions) do
          { slug: 'html', settings: [{ name: 'text', value: 'test' }] }
        end
        before { 
          @response = subject
        }

        it "creates a widget in the drop target with settings" do
          expect(drop_target.widgets.first.slug).to eq(html_widget.slug)
          expect(@response.drop_target).to_not be_nil
          expect(@response.settings).to_not be_empty
        end
      end

      context "valid instructions - has settings, no drop target" do
        let(:instructions) do
          { slug: 'html', settings: [{ name: 'text', value: 'test' }] }
        end
        let(:drop_target) { nil }
        before { @response = subject }
      end
    end

    context "content stripe widget" do
      subject { seeder.seed }
      
      context "valid instructions - has drop target (required), no widgets" do
        let(:instructions) { { slug: 'content-stripe' } }
        before { @response = subject }

        it "creates a content stripe widget in the drop target" do
          expect(drop_target.widgets.first.slug).to eq(content_stripe_widget.slug)
          expect(@response.drop_target).to_not be_nil
          binding.pry
        end
      end
    end

    context "column widget" do
      subject { seeder.seed }
      
      context "valid instructions - has drop target, no widgets" do
        let(:instructions) { { slug: 'column' } }
        before { @response = subject }

        it "creates a column widget in the drop target" do
          expect(drop_target.widgets.first.slug).to eq(column_widget.slug)
          expect(@response.drop_target).to_not be_nil
        end
      end

      context "valid instructions - no drop target, no widgets" do
        let(:instructions) { { slug: 'column' } }
        let(:drop_target) { nil }
        before { @response = subject }

        it "creates a stand-alone widget - no drop target" do
          expect(@response.slug).to eq(column_widget.slug)
          expect(@response.drop_target).to be_nil
        end
      end
    end

    context "no instructions" do
      let(:instructions) { nil }
      subject { seeder.seed }
      before { @response = subject }
      it "logs error and returns nil" do
        expect(@response).to be_nil
      end
    end

    context "invalid instructions" do
      let(:instructions) { { wrong: true } }
      subject { seeder.seed }
      before { @response = subject }
      it "logs error and returns nil" do
        expect(@response).to be_nil
      end
    end
  end
end