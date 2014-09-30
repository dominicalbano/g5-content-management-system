class GardenWidgetSerializer < ActiveModel::Serializer
  attributes  :id,
              :name,
              :thumbnail,
              :url,
              :widget_type
end
