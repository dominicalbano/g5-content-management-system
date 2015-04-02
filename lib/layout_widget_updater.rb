class LayoutWidgetUpdater
  def initialize(setting, name_settings, id_settings)
    @setting = setting
    @name_settings = name_settings
    @id_settings = id_settings
  end

  def update
    if garden_widget_name_setting?
      create_new_widget
      destroy_old_widget
      assign_new_widget
    end
  end

  def create_new_widget
    @new_widget = Widget.create(garden_widget_id: garden_widget_id)
  end

  def destroy_old_widget
    Widget.find_by_id(widget_id_setting_value).try(:destroy) if widget_id_setting_value
  rescue ActiveRecord::RecordNotFound
  end

  def assign_new_widget
    widget_id_setting.update_attributes(value: @new_widget.id) if widget_id_setting
  end

  def garden_widget_name_setting?
    @name_settings.include?(@setting.name)
  end

  def garden_widget_id
    GardenWidget.where(name: @setting.best_value).first.try(:id)
  end

  def widget_id_setting_name
    @id_settings[@name_settings.index(@setting.name)]
  end

  def widget_id_setting
    @setting.owner.settings.where(name: widget_id_setting_name).first
  end

  def widget_id_setting_value
    widget_id_setting.try(:value)
  end
end
