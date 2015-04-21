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

  def setting_names(widget, name_type)
    (1..6).map { |idx| "#{widget}_#{idx}_widget_#{name_type}" }
  end

  def name_setting_names(widget)
    setting_names(widget, 'name')
  end

  def id_setting_names(widget)
    setting_names(widget, 'id')
  end

  def updater(widget)
    LayoutWidgetUpdater.new(self, name_setting_names(widget), id_setting_names(widget))
  end
end

