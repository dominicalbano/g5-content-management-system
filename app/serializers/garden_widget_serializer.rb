class GardenWidgetSerializer < ActiveModel::Serializer
  attributes  :id,
              :name,
              :thumbnail,
              :url,
              :widget_type,
              :widget_popover
end