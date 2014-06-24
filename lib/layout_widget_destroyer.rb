class LayoutWidgetDestroyer
  def initialize(setting, id_settings)
    @setting = setting
    @id_settings = id_settings
  end

  def destroy
    @id_settings.each do |setting|
      widget_id = widget_id_for(setting)
      obliterate(widget_id) if widget_id.present?
    end
  end

protected

  def widget_id_for(setting)
    @setting.owner.settings.where(name: setting).first.try(:value)
  end

  def obliterate(widget_id)
    Widget.find(widget_id).destroy if Widget.exists?(widget_id)
  end
end
