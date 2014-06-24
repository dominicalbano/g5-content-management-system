module SettingRowWidgetGardenWidgets
  extend ActiveSupport::Concern

  ROW_GARDEN_WIDGET_NAME_SETTINGS = ["column_one_widget_name",
    "column_two_widget_name", "column_three_widget_name",
    "column_four_widget_name"]

  ROW_WIDGET_ID_SETTINGS = ["column_one_widget_id", "column_two_widget_id",
    "column_three_widget_id", "column_four_widget_id"]

  included do
    after_update :update_row_widget_id_setting
    after_destroy :destroy_row_widget_widgets
  end

  def update_row_widget_id_setting
    if value_changed?
      LayoutWidgetUpdater.
        new(self, ROW_GARDEN_WIDGET_NAME_SETTINGS, ROW_WIDGET_ID_SETTINGS).update
    end
  end

  def destroy_row_widget_widgets
    LayoutWidgetDestroyer.new(self, ROW_WIDGET_ID_SETTINGS).destroy
  end
end
