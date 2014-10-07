class GardenWidgetSerializer < ActiveModel::Serializer
  attributes  :id,
              :name,
              :thumbnail,
              :url
end
