class WebsiteTemplateSeederSerializer < ActiveModel::Serializer
  attributes  :name,
              :web_layout,
              :web_theme,
              :drop_targets

  def web_layout
    { slug: object.web_layout.garden_web_layout.slug }
  end

  def web_theme
    { slug: object.web_theme.garden_web_theme.slug }
  end

  def drop_targets
    object.drop_targets.inject([]) do |arr, dt|
      arr << DropTargetSeederSerializer.new(dt, {root: false}).as_json
      arr
    end
  end
end
