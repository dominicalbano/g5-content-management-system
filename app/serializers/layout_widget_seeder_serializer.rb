class LayoutWidgetSeederSerializer < ActiveModel::Serializer
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
      w = find_widget(setting_name)
      arr << WidgetSeederSerializer.new(w, {root: false}).as_json if w
      arr
    end
  end

  def widgets
    nested_widgets(widget_list)
  end

  def widget_list
    (1..count).map { |idx| widget_setting_id(idx) }
  end

  def nested_widget_slugs
    nested_widget_list.map(&:slug)
  end

  def nested_widget_list
    (1..count).inject([]) do |arr,pos| 
      arr << nested_widget(pos) if nested_widget(pos)
      arr
    end
  end

  def nested_widget(position)
    child = object.get_child_widget(position)
    return count >= position ? child : nil
  end
end
