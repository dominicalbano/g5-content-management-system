require "spec_helper"

shared_examples_for SettingRowWidgetGardenWidgets do
  describe "When availble_garden_widgets setting" do
    let!(:widget) { Fabricate(:widget) }
    let!(:corresponding_setting) { Fabricate(:setting,
      name: SettingRowWidgetGardenWidgets::ROW_WIDGET_ID_SETTINGS[0],
      owner: widget) }
    let!(:described_instance) { Fabricate(:setting,
      name: SettingRowWidgetGardenWidgets::ROW_GARDEN_WIDGET_NAME_SETTINGS[0],
      owner: widget) }

    describe "After update" do
      it "Tries to update corresponding setting" do
        described_instance.should_receive(:update_row_widget_id_setting)
        described_instance.save
      end

      describe "When value does not change" do
        it "Does not update corresponding setting" do
          expect { described_instance.save }.to_not change { corresponding_setting.reload.value }
        end
      end

      describe "When value changes" do
        before { described_instance.value = "Foo" }

        it "Updates corresponding setting" do
          expect { described_instance.save }.to change { corresponding_setting.reload.value }
        end
      end
    end

    describe "#after_destroy" do
      it "destroy's the setting's widget's child widgets" do
        described_instance.should_receive(:destroy_row_widget_widgets)
        described_instance.destroy
      end
    end
  end

  describe "When not an avaiable_garden_widgets setting" do
    let(:described_instance) { Fabricate(:setting) }

    describe "After update" do
      it "Does not try to update corresponding setting" do
        described_instance.should_not_receive(:update_widget_id_setting)
        described_instance.save
      end
    end
  end
end

describe Setting do
  it_behaves_like SettingRowWidgetGardenWidgets
end
