module SettingLayoutWidgetGardenWidgets
  extend ActiveSupport::Concern

  LAYOUT_WIDGETS = ["row", "column"]

  included do
    after_update :update_layout_widget_id_setting
    after_destroy :destroy_layout_widget_widgets
  end

  def update_layout_widget_id_setting
    #the rails generated method 'value_changed?' was always returning true
    LAYOUT_WIDGETS.each { |widget| updater(widget).update } if the_value_has_changed?
  end

  def destroy_layout_widget_widgets
    LayoutWidgetDestroyer.new(self).destroy
  end

private

  #the rails generated method 'value_changed?' was always returning true
  def the_value_has_changed?
    self.value != self.value_was
  end

  def name_setting_names(widget)
    [
      "#{widget}_1_widget_name", "#{widget}_2_widget_name",
      "#{widget}_3_widget_name", "#{widget}_4_widget_name",
      "#{widget}_5_widget_name", "#{widget}_6_widget_name"
    ]
  end

  def id_setting_names(widget)
    [
      "#{widget}_1_widget_id", "#{widget}_2_widget_id",
      "#{widget}_3_widget_id", "#{widget}_4_widget_id",
      "#{widget}_5_widget_id", "#{widget}_6_widget_id"
    ]
  end

  def updater(widget)
    LayoutWidgetUpdater.new(self, name_setting_names(widget), id_setting_names(widget))
  end
end

