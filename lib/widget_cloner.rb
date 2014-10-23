class WidgetCloner
  def initialize(widget, target_drop_target)
    @widget = widget
    @target_drop_target = target_drop_target
  end

  def clone
    new_widget = @widget.dup
    new_widget.update(drop_target: @target_drop_target)

    clone_widget_settings(@widget, new_widget)
  end

  private

  def clone_widget_settings(source_widget, target_widget)
    source_widget.settings.each do |setting|
      next if setting.nam =~ /widget_id$/
      target_widget.settings.where(name: setting.name).first.update(value: setting.value)
      next unless setting.name =~ /widget_name$/
      clone_child_widgets(source_widget, target_widget, setting)
    end
  end

  def clone_child_widgets(source_widget, target_widget, setting)
    target_widget   = Widget.find(target_widget.id)
    new_widget      = setting_value_for(target_widget, setting)
    original_widget = setting_value_for(source_widget, setting)

    if layout_setting?
      clone_widget_settings(new_widget, original_widget)
    else
      original_widget.settings.each do |original_widget_setting|
        update_setting(original_widget_setting, new_widget)
      end
    end
  rescue
  end

  def update_setting(original_widget_setting, new_widget)
    new_setting = new_widget.settings.where(name: original_widget_setting.name).first
    new_setting.update(value: original_widget_setting.value)
  end

  def setting_value_for(widget, setting)
    Widget.find(widget.settings.where({name: setting.name.gsub('_name', '_id')}).first.value)
  end

  def layout_setting?
    setting.value == 'Row' || setting.value == 'Column'
  end
end
