class LayoutWidgetDestroyer
  def initialize(setting)
    @setting = setting
  end

  def destroy
    Widget.destroy(@setting.value) if existing_child_widget_setting?
  end

protected

  def existing_child_widget_setting?
    @setting.name =~ /widget_id/ && Widget.exists?(@setting.value)
  end
end
