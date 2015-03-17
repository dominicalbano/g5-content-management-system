class WebPageTemplateSeederSerializer < ActiveModel::Serializer
  attributes  :name,
              :title,
              :drop_targets

  def drop_targets
    object.drop_targets.inject([]) do |arr, dt|
      arr << DropTargetSeederSerializer.new(dt, {root: false}).as_json
      arr
    end
  end

  def to_yaml_file
    file_name = "#{object.website.urn}_#{object.name}".downcase.underscore.gsub(' ','_')
    File.write("#{WEB_PAGE_DEFAULTS_PATH}/#{file_name}.yml", self.as_json({root: "web_page_templates"}).to_yaml)
    file_name
  end
end
