class DropTargetSeederSerializer < ActiveModel::Serializer
  attributes  :html_id,
              :widgets

  def widgets
    object.widgets.map do |w|
      WidgetSeederSerializer.new(w, {root: false}).as_json
    end
  end
end
