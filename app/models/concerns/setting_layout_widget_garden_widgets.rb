module SettingLayoutWidgetGardenWidgets
  extend ActiveSupport::Concern

  LAYOUT_WIDGETS = ["row", "column"]

  included do
    after_update :update_layout_widget_id_setting
    after_destroy :destroy_layout_widget_widgets
  end

  def update_layout_widget_id_setting
    return unless value_changed?

    LAYOUT_WIDGETS.each do |widget|
      LayoutWidgetUpdater.new(self, name_settings(widget), id_settings(widget)).update
    end
  end

  def destroy_layout_widget_widgets
    LAYOUT_WIDGETS.each do |widget|
      LayoutWidgetDestroyer.new(self, id_settings(widget)).destroy
    end
  end

  def name_settings(widget)
    [
      "#{widget}_one_widget_name", "#{widget}_two_widget_name",
      "#{widget}_three_widget_name", "#{widget}_four_widget_name"
    ]
  end

  def id_settings(widget)
    [
      "#{widget}_one_widget_id", "#{widget}_two_widget_id",
      "#{widget}_three_widget_id", "#{widget}_four_widget_id"
    ]
  end
end
