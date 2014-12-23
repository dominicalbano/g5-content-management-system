require "spec_helper"

describe Cloner::WidgetCloner do
  let(:widget_cloner) { described_class.new(widget, target_drop_target) }
  let!(:website) { Fabricate(:website) }
  let!(:template) { Fabricate(:web_template, website: website) }
  let!(:target_drop_target) { Fabricate(:drop_target, web_template: template) }
  let!(:row_garden_widget) { Fabricate(:row_garden_widget) }

  let!(:html_garden_widget) { Fabricate(:html_garden_widget) }
  let!(:widget) { Fabricate(:widget, garden_widget: row_garden_widget) }
  let!(:child_widget) { Fabricate(:widget, drop_target: nil, garden_widget: html_garden_widget) }

  let!(:widget_id_setting) do
    Fabricate(:setting, owner: widget, name: "column_one_widget_id", value: child_widget.id )
  end

  let!(:widget_name_setting) do
    Fabricate(:setting, owner: widget, name: "column_one_widget_name", value: child_widget.name )
  end



  describe "#clone" do
    context "before anything happens" do
      specify { expect(Widget.all.size).to eq(2) }
      specify { expect(Setting.all.size).to eq(2) }
    end

    context "after running clone" do
      before do
        row_garden_widget.settings.clear
        row_garden_widget.settings << widget_id_setting
        row_garden_widget.settings << widget_name_setting

        widget.settings << widget_id_setting
        widget.settings << widget_name_setting
        Cloner::WidgetCloner.new(widget, target_drop_target).clone
      end

      describe "widget cloning" do
        it "clones a new widget" do
          expect(Widget.all.size).to eq(4)
        end

        it "assigns the new widget to the new drop target" do
          expect(target_drop_target.widgets.size).to eq(1)
        end
      end

      describe "setting cloning" do
        it "clones widget settings" do
          expect(Setting.all.size).to eq(4)
        end

        it "assigns the new widget to the new drop target" do
          expect(target_drop_target.widgets.size).to eq(1)
        end
      end

      describe "child widget cloning" do
        it "assigns the child widget to the new widget" do
          expect(target_drop_target.widgets.first.widgets.size).to eq(1)
        end
      end
    end
  end
end
