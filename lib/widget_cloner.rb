class WidgetCloner
  def initialize(widget, target_drop_target)
    @widget = widget
    @target_drop_target = target_drop_target
  end

  def clone
    new_widget = @widget.dup
    new_widget.update(drop_target: @target_drop_target)

    clone_settings(@widget.settings, new_widget)
    process_widget(@widget, new_widget)
  end

  private

  def clone_settings(settings, new_widget)
    return unless new_widget.settings.blank?

    @widget.settings.each do |setting|
      new_setting = setting.dup
      new_setting.update(owner: new_widget)
    end
  end

  def process_widget(source_widget, target_widget)
    source_widget.settings.each do |setting|
      next if setting.name =~ /widget_id$/
      set_setting(target_widget, setting)
      next unless setting.name =~ /widget_name$/
      clone_child_widgets(source_widget, target_widget, setting)
    end
  end

  def clone_child_widgets(source_widget, target_widget, setting)
    new_widget = setting_value_for(target_widget, setting)
    original_widget = setting_value_for(source_widget, setting)
    process_setting(new_widget, original_widget)
  rescue => e
    Rails.logger.info "ERRORED! #{e.message}"
  end

  def set_setting(target_widget, setting)
    found_setting = target_widget.settings.where(name: setting.name).first
    found_setting.update(value: setting.value) if found_setting
  end

  def process_setting(new_widget, original_widget)
    if layout_setting?
      clone_widget_settings(new_widget, original_widget)
    else
      original_widget.settings.each do |original_widget_setting|
        update_setting(original_widget_setting, new_widget)
      end
    end
  end

  def update_setting(original_widget_setting, new_widget)
    new_setting = new_widget.settings.where(name: original_widget_setting.name).first
    new_setting.update(value: original_widget_setting.value)
  end

  def setting_value_for(widget, setting)
    Widget.find(widget.settings.where(name: setting.name.gsub('_name', '_id')).first.value)
  end

  def layout_setting?
    setting.value == 'Row' || setting.value == 'Column'
  end
end
