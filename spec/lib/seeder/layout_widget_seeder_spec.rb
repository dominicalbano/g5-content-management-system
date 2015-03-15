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

  let!(:defaults) { HashWithIndifferentAccess.new(YAML.load_file("#{Rails.root}/spec/support/website_instructions/defaults_with_settings.yml")) }
  let!(:cs_instructions) { defaults[:web_page_templates].second[:drop_targets].first[:widgets].first }
  let!(:col_instructions) { defaults[:web_page_templates].third[:drop_targets].first[:widgets].first }
  let!(:complex_instructions) { defaults[:web_page_templates].fourth[:drop_targets].first[:widgets].first }

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
            expect(@response.get_setting('row_layout').value).to eq(instructions[:row_layout])
          end

          it "creates correct nested widget settings for content stripe widget" do
            expect(@response.child_widgets.size).to eq(instructions[:widgets].size)
            expect(@response.child_widgets.first.slug).to eq(instructions[:widgets].first[:slug])
            expect(@response.child_widgets.second.slug).to eq(instructions[:widgets].second[:slug])
            expect(@response.get_setting_value('column_one_widget_name')).to eq(html_widget.name)
            expect(@response.get_setting_value('column_two_widget_name')).to eq(map_widget.name)
          end
        end
      end

      context "valid instructions - content stripe with nested columns with widgets" do
        let(:instructions) { complex_instructions  }
        context "has drop target" do
          before do
            @response = subject
            @first_col = @response.reload.child_widgets.first
            @second_col = @response.reload.child_widgets.second
          end

          it "creates a content stripe widget in the drop target" do
            expect(drop_target.widgets.first.slug).to eq(content_stripe_widget.slug)
            expect(@response.drop_target).to_not be_nil
          end

          it "creates correct layout setting for content stripe widget" do
            expect(@response.get_setting_value('row_layout')).to eq(instructions[:row_layout])
          end

          it "creates correct nested column widget settings for content stripe widget" do
            expect(@response.child_widgets.size).to eq(instructions[:widgets].size)
            expect(@first_col.slug).to eq(instructions[:widgets].first[:slug])
            expect(@second_col.slug).to eq(instructions[:widgets].second[:slug])
            expect(@response.get_setting_value('column_one_widget_name')).to eq(column_widget.name)
            expect(@response.get_setting_value('column_two_widget_name')).to eq(column_widget.name)
          end

          it "creates correct nested widget settings for nested column widgets inside content stripe widget" do
            expect(@first_col.child_widgets.size).to eq(instructions[:widgets].first[:widgets].size)
            expect(@second_col.child_widgets.size).to eq(instructions[:widgets].second[:widgets].size)
            expect(@first_col.child_widgets.first.slug).to eq(instructions[:widgets].first[:widgets].first[:slug])
            expect(@first_col.child_widgets.second.slug).to eq(instructions[:widgets].first[:widgets].second[:slug])
            expect(@second_col.child_widgets.first.slug).to eq(instructions[:widgets].second[:widgets].first[:slug])
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
            expect(@response.get_setting_value('row_count')).to eq(instructions[:row_count])
          end

          it "creates correct nested widget settings for column widget" do
            expect(@response.child_widgets.size).to eq(instructions[:widgets].size)
            expect(@response.child_widgets.first.slug).to eq(instructions[:widgets].first[:slug])
            expect(@response.child_widgets.second.slug).to eq(instructions[:widgets].second[:slug])
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
            expect(@response.get_setting('row_count').value).to eq(instructions[:row_count])
          end

          it "creates correct nested widget settings for column widget" do
            expect(@response.child_widgets.size).to eq(instructions[:widgets].size)
            expect(@response.child_widgets.first.slug).to eq(instructions[:widgets].first[:slug])
            expect(@response.child_widgets.second.slug).to eq(instructions[:widgets].second[:slug])
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