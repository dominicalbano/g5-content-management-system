require "spec_helper"

shared_examples_for SettingLayoutWidgetGardenWidgets do
  before do
    @row_garden_widget = Fabricate(:row_garden_widget)
    @row_garden_widget.settings << Fabricate.build(:column_one_widget_id)
    @row_garden_widget.settings << Fabricate.build(:column_one_widget_name)
    @row_garden_widget.save
  end

  describe "When availble_garden_widgets setting" do
    let(:row_widget) { Fabricate(:widget, garden_widget: @row_garden_widget) }
    let(:other_widget) {Fabricate(:widget)}

    describe "on creation" do
      it "does not create extra widgets" do
        expect{Fabricate(:widget, garden_widget: @row_garden_widget)}.to change{Widget.count}.by(1)
      end
    end

    describe "After update" do
      it "Tries to update widget_id_setting" do
        widget_name_setting = row_widget.settings.where(name: "column_one_widget_name").first
        widget_name_setting.should_receive(:update_layout_widget_id_setting)
        widget_name_setting.save
      end

      it "Does not update widget_id_setting setting when value doesnt change" do
        widget_name_setting = row_widget.settings.where(name: "column_one_widget_name").first
        widget_id_setting = row_widget.settings.where(name: "column_one_widget_name").first
        expect { widget_name_setting.save }.to_not change { widget_id_setting.reload.value }
      end

      describe "When value changes" do
        before do
          @widget_name_setting = row_widget.settings.where(name: "column_one_widget_name").first
          @widget_id_setting = row_widget.settings.where(name: "column_one_widget_id").first
        end

        it "Updates widget_id_setting setting" do
          @widget_name_setting.value = other_widget.name
          expect { @widget_name_setting.save }.to change { @widget_id_setting.reload.value }
        end
      end
    end

    describe "#after_destroy" do
      it "destroy's the setting's widget's child widgets" do
        widget_name_setting = row_widget.settings.where(name: "column_one_widget_name").first
        widget_name_setting.should_receive(:destroy_layout_widget_widgets)
        widget_name_setting.destroy
      end
    end
  end

  describe "When not an avaiable_garden_widgets setting" do
    let(:setting) { Fabricate(:setting_with_owner) }

    describe "After update" do
      it "Does not try to update widget_id_setting setting" do
        setting.should_not_receive(:update_widget_id_setting)
        setting.save
      end
    end
  end
end

describe Setting do
  it_behaves_like SettingLayoutWidgetGardenWidgets
end

