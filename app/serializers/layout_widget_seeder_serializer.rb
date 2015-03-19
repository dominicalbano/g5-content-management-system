class LayoutWidgetSeederSerializer < ActiveModel::Serializer
  protected

  def widget_id(setting_name)
    object.get_setting_value(setting_name)
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
    (1..object.max_widgets).map do |idx| 
      "#{object.child_widget_setting_prefix(idx)}id"
    end
  end

  def nested_widget_slugs
    nested_widget_list.map(&:slug)
  end

  def nested_widget_list
    (1..object.max_widgets).inject([]) do |arr,pos| 
      child = object.get_child_widget(pos)
      arr << child if child 
      arr
    end
  end
end
