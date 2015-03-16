require "spec_helper"

describe Seeder::LayoutWidgetSeeder do
  let!(:client) { Fabricate(:client) }
  let!(:location) { Fabricate(:location) }
  let(:website) { Fabricate(:website, owner: location) }
  let(:web_template) { Fabricate(:web_page_template, website: website) }
  let(:drop_target) { Fabricate(:drop_target, web_template: web_template) }
  let(:seeder) { Seeder::WidgetSeeder.new(drop_target, instructions) }
  
  # need to fabricate garden widgets for this to work
  let!(:html_widget) { Fabricate(:html_garden_widget) }
  let!(:map_widget) { Fabricate(:garden_widget, name: 'map') }
  let!(:gallery_widget) { Fabricate(:garden_widget, name: 'gallery') }
  let!(:column_widget) { Fabricate(:column_garden_widget) }
  let!(:content_stripe_widget) { Fabricate(:row_garden_widget) }

  let!(:defaults) { load_yaml_file("#{Rails.root}/spec/support/website_instructions/defaults_with_settings.yml") }
  let!(:cs_page) { defaults[:web_page_templates].find { |wt| wt[:name] == 'Content Stripe' } }
  let!(:col_page) { defaults[:web_page_templates].find { |wt| wt[:name] == 'Column' } }
  let!(:complex_page) { defaults[:web_page_templates].find { |wt| wt[:name] == 'Complex' } }

  let!(:cs_instructions) { cs_page[:drop_targets].first[:widgets].first }
  let!(:col_instructions) { col_page[:drop_targets].first[:widgets].first }
  let!(:complex_instructions) { complex_page[:drop_targets].first[:widgets].first }

  describe "#seed" do
    context "content stripe widget" do
      let(:instructions) { cs_instructions  }
      subject { seeder.seed }
      
      context "valid instructions - single content stripe with widgets" do
        context "has drop target" do
          before { @response = subject }

          it "creates a content stripe widget in the drop target" do
            expect(drop_target.widgets.first.slug).to eq(content_stripe_widget.slug)
            expect(@response.drop_target).to_not be_nil
          end

          it "creates correct layout setting for content stripe widget" do
            expect(@response.get_setting('row_layout').value).to eq(cs_instructions[:row_layout])
          end
        
          it "creates correct child widget settings for content stripe widget" do
            expect(@response.reload.child_widgets.size).to eq(cs_instructions[:widgets].size)
            expect(@response.get_child_widget(1).slug).to eq(html_widget.slug)
            expect(@response.get_child_widget(2).slug).to eq(map_widget.slug)
            expect(@response.get_setting_value('column_one_widget_name')).to eq(html_widget.name)
            expect(@response.get_setting_value('column_two_widget_name')).to eq(map_widget.name)
          end
        end
      end

      context "valid instructions - content stripe with child columns with widgets" do
        let(:instructions) { complex_instructions  }
        context "has drop target" do
          before do
            @response = subject
            @first_col = @response.get_child_widget(1)
            @second_col = @response.get_child_widget(2)
          end

          it "creates a content stripe widget in the drop target" do
            expect(drop_target.widgets.first.slug).to eq(content_stripe_widget.slug)
            expect(@response.drop_target).to_not be_nil
          end

          it "creates correct layout setting for content stripe widget" do
            expect(@response.get_setting_value('row_layout')).to eq(complex_instructions[:row_layout])
          end

          it "creates correct child column widget settings for content stripe widget" do
            expect(@first_col.slug).to eq(complex_instructions[:widgets].first[:slug])
            expect(@second_col.slug).to eq(complex_instructions[:widgets].second[:slug])
            expect(@response.get_setting_value('column_one_widget_name')).to eq(column_widget.name)
            expect(@response.get_setting_value('column_two_widget_name')).to eq(column_widget.name)
          end

          it "creates correct settings for child column widgets inside content stripe widget" do
            expect(@first_col.reload.child_widgets.size).to eq(complex_instructions[:widgets].first[:widgets].size)
            expect(@second_col.reload.child_widgets.size).to eq(complex_instructions[:widgets].second[:widgets].size)
            expect(@first_col.get_child_widget(1).slug).to eq(complex_instructions[:widgets].first[:widgets].first[:slug])
            expect(@first_col.get_child_widget(2).slug).to eq(complex_instructions[:widgets].first[:widgets].second[:slug])
            expect(@second_col.get_child_widget(1).slug).to eq(complex_instructions[:widgets].second[:widgets].first[:slug])
          end
        end
      end
    end

    context "column widget" do
      let(:instructions) { col_instructions }
      subject { seeder.seed }
      
      context "valid instructions - single column with widgets" do
        context "has drop target" do
          before { @response = subject }

          it "creates a column widget in the drop target" do
            expect(drop_target.widgets.first.slug).to eq(column_widget.slug)
            expect(@response.slug).to eq(column_widget.slug)
            expect(@response.drop_target).to_not be_nil
          end

          it "creates correct layout setting for column widget" do
            expect(@response.get_setting_value('row_count')).to eq(col_instructions[:row_count])
          end
        
          it "creates correct child widget settings for column widget" do
            expect(@response.reload.child_widgets.size).to eq(col_instructions[:widgets].size)
            expect(@response.get_child_widget(1).slug).to eq(col_instructions[:widgets].first[:slug])
            expect(@response.get_child_widget(2).slug).to eq(col_instructions[:widgets].second[:slug])
            expect(@response.get_setting_value('row_one_widget_name')).to eq(gallery_widget.name)
            expect(@response.get_setting_value('row_two_widget_name')).to eq(html_widget.name)
          end
        end

        context "has no drop target" do
          let(:drop_target) { nil }
          before { @response = subject }

          it "creates a standalone column widget - no drop target" do
            expect(@response.slug).to eq(column_widget.slug)
            expect(@response.drop_target).to be_nil
          end

          it "creates correct layout setting for column widget" do
            expect(@response.get_setting('row_count').value).to eq(col_instructions[:row_count])
          end
        
          it "creates correct child widget settings for column widget" do
            expect(@response.reload.child_widgets.size).to eq(col_instructions[:widgets].size)
            expect(@response.get_child_widget(1).slug).to eq(col_instructions[:widgets].first[:slug])
            expect(@response.get_child_widget(2).slug).to eq(col_instructions[:widgets].second[:slug])
            expect(@response.get_setting_value('row_one_widget_name')).to eq(gallery_widget.name)
            expect(@response.get_setting_value('row_two_widget_name')).to eq(html_widget.name)
          end
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