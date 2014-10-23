require "spec_helper"

describe WebTemplateCloner do
  let(:widget_cloner) { WidgetCloner.new(widget, target_drop_target) }
  let!(:target_drop_target) { Fabricate(:drop_target) }
  let!(:row_garden_widget) { Fabricate(:row_garden_widget) }
  let!(:widget) { Fabricate(:widget, garden_widget: row_garden_widget) }
  let!(:child_widget) { Fabricate(:widget, drop_target: nil) }

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
      before { widget_cloner.clone }

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
    end
  end
end
