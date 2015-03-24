class WebPageTemplateSeederSerializer < ActiveModel::Serializer
  attributes  :name,
              :title,
              :drop_targets

  include SeederSerializerToYamlFile

  def drop_targets
    object.drop_targets.inject([]) do |arr, dt|
      arr << DropTargetSeederSerializer.new(dt, {root: false}).as_json
      arr
    end
  end

  def file_name
    page = object.name
    name = object.website.name
    vert = object.website.client.vertical
    "#{vert}_#{name}_#{page}"
  end

  def file_path
    WEB_PAGE_DEFAULTS_PATH
  end
end
