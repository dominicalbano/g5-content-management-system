class WebsiteTemplateSpinupSerializer < ActiveModel::Serializer
  attributes  :name,
              :web_layout,
              :web_theme,
              :drop_targets,
              :web_home_template,
              :web_page_templates

  def web_layout
    { slug: object.web_layout.garden_web_layout.slug }
  end

  def web_theme
    { slug: object.web_theme.garden_web_theme.slug }
  end

  def drop_targets
    object.drop_targets.inject([]) do |arr, dt|
      arr << DropTargetSpinupSerializer.new(dt, {root: false}).as_json
      arr
    end
  end

  def web_home_template
    WebPageTemplateSpinupSerializer.new(object.website.web_home_template, {root: false}).as_json
  end

  def web_page_templates
    object.website.web_page_templates.inject([]) do |arr, wt|
      arr << WebPageTemplateSpinupSerializer.new(wt, {root: false}).as_json
      arr
    end
  end
end
