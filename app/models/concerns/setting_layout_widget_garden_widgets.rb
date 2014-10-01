module SettingLayoutWidgetGardenWidgets
  extend ActiveSupport::Concern

  LAYOUT_WIDGETS = ["row", "column"]

  included do
    after_update :update_layout_widget_id_setting
    after_destroy :destroy_layout_widget_widgets
  end

  def update_layout_widget_id_setting
    LAYOUT_WIDGETS.each { |widget| updater(widget).update } if value_changed?
  end

  def destroy_layout_widget_widgets
    LayoutWidgetDestroyer.new(self).destroy
  end

private

  def name_setting_names(widget)
    [
      "#{widget}_one_widget_name", "#{widget}_two_widget_name",
      "#{widget}_three_widget_name", "#{widget}_four_widget_name",
      "#{widget}_five_widget_name", "#{widget}_six_widget_name"
    ]
  end

  def id_setting_names(widget)
    [
      "#{widget}_one_widget_id", "#{widget}_two_widget_id",
      "#{widget}_three_widget_id", "#{widget}_four_widget_id",
      "#{widget}_five_widget_id", "#{widget}_six_widget_id"
    ]
  end

  def updater(widget)
    LayoutWidgetUpdater.new(self, name_setting_names(widget), id_setting_names(widget))
  end
end

