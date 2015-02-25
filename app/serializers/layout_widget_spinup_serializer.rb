class LayoutWidgetSpinupSerializer < ActiveModel::Serializer
  protected

  def widget_id(setting_name)
    object.settings.where(name: setting_name).first.try(:value)
  end

  def find_widget(setting_name)
    id = widget_id(setting_name)
    Widget.where(id: id).first if id
  end

  def nested_widgets(widget_ids)
    widget_ids.inject([]) do |arr, setting_name|
      arr << WidgetSpinupSerializer.new(find_widget(setting_name), {root: false}).as_json unless widget_id(setting_name).blank?
      arr
    end
  end  
end
