module SettingColumnWidgetGardenWidgets
  extend ActiveSupport::Concern

  COLUMN_GARDEN_WIDGET_NAME_SETTINGS = [
    "row_one_widget_name", "row_two_widget_name",
    "row_three_widget_name", "row_four_widget_name"
  ]

  COLUMN_WIDGET_ID_SETTINGS = [
    "row_one_widget_id", "row_two_widget_id",
    "row_three_widget_id", "row_four_widget_id"
  ]

  included do
    after_update :update_column_widget_id_setting
    after_destroy :destroy_column_widget_widgets
  end

  def update_column_widget_id_setting
    if value_changed?
      LayoutWidgetUpdater.
        new(self, COLUMN_GARDEN_WIDGET_NAME_SETTINGS, COLUMN_WIDGET_ID_SETTINGS).update
    end
  end

  def destroy_column_widget_widgets
    LayoutWidgetDestroyer.new(self, COLUMN_WIDGET_ID_SETTINGS).destroy
  end
end
