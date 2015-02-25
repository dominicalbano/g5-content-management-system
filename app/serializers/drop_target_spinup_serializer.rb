class DropTargetSpinupSerializer < ActiveModel::Serializer
  attributes  :html_id,
              :widgets

  def widgets
    object.widgets.inject([]) do |arr, w|
      arr << WidgetSpinupSerializer.new(w, {root: false}).as_json
      arr
    end
  end
end
