class WebPageTemplateSpinupSerializer < ActiveModel::Serializer
  attributes  :name,
              :title,
              :drop_targets

  def drop_targets
    object.drop_targets.inject([]) do |arr, dt|
      arr << DropTargetSpinupSerializer.new(dt, {root: false}).as_json
      arr
    end
  end
end
