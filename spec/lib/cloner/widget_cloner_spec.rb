require "spec_helper"

describe Cloner::WidgetCloner do
  describe "#clone" do
    before do

      website = Fabricate(:website)
      template = Fabricate(:web_template, website: website)
      @target_drop_target = Fabricate(:drop_target, web_template: template)

      row_garden_widget = Fabricate(:row_garden_widget)
      row_garden_widget.settings.push({:name=>"column_one_widget_name", :editable=>"true", :default_value=>"", :categories=>["Instance"]})
      row_garden_widget.settings.push({:name=>"column_one_widget_id", :editable=>"true", :default_value=>"", :categories=>["Instance"]})
      row_garden_widget.save

      html_garden_widget = Fabricate(:html_garden_widget)

      @row_widget = Fabricate(:widget, garden_widget: row_garden_widget)
      child_widget = Fabricate(:widget, drop_target: nil, garden_widget: html_garden_widget)


      #widget_id_setting = Fabricate(:setting, owner: @row_widget, name: "column_one_widget_id", value: child_widget.id )
      #widget_name_setting = Fabricate(:setting, owner: @row_widget, name: "column_one_widget_name", value: child_widget.name )

      #@row_widget.settings << widget_id_setting
      @row_widget.settings.where(name: "column_one_widget_name").first.update_attribute(:value, child_widget.name)
      @row_widget.reload

      #widget_cloner = described_class.new(widget, target_drop_target) 
      Cloner::WidgetCloner.new(@row_widget, @target_drop_target).clone

    end

    context "after running clone" do
      describe "widget cloning" do
        it "clones a new widget" do
          expect(Widget.count).to eq(4)
        end

        it "assigns the new widget to the new drop target" do
          expect(@target_drop_target.widgets.size).to eq(1)
        end
      end

      describe "setting cloning" do
        it "clones widget settings" do
          expect(Setting.all.size).to eq(4)
        end

        it "assigns the new widget to the new drop target" do
          expect(@target_drop_target.widgets.size).to eq(1)
        end
      end

      describe "child widget cloning" do
        it "assigns the child widget to the new widget" do
          expect(@target_drop_target.widgets.first.widgets.size).to eq(1)
        end
      end
    end
  end
end

