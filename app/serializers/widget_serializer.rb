class WidgetSerializer < ActiveModel::Serializer

  attributes  :id,
              :garden_widget_id,
              :drop_target_id,
              :name,
              :thumbnail,
              :url,
              :section,
              :display_order
end
