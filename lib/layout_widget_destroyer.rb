class LayoutWidgetDestroyer
  def initialize(settings)
    @settings = settings
  end

  def destroy
    @settings.each do |setting|
      Widget.destroy(setting.value) if existing_child_widget_setting?(setting)
    end
  end

protected

  def existing_child_widget_setting?(setting)
    setting.name =~ /widget_id/ && Widget.exists?(setting.value)
  end
end
