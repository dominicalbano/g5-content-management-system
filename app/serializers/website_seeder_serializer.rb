class WebsiteSeederSerializer < ActiveModel::Serializer
  include SeederSerializerToYamlFile

  def as_json(options=nil)
    {
      website_template: website_template,
      web_home_template: web_home_template,
      web_page_templates: web_page_templates
    }
  end

  def website_template
    WebsiteTemplateSeederSerializer.new(object.website.website_template, {root: false}).as_json
  end

  def web_home_template
    WebPageTemplateSeederSerializer.new(object.website.web_home_template, {root: false}).as_json
  end

  def web_page_templates
    object.website.web_page_templates.inject([]) do |arr, wt|
      arr << WebPageTemplateSeederSerializer.new(wt, {root: false}).as_json
      arr
    end
  end

  def file_path
    WEBSITE_DEFAULTS_PATH
  end

  def file_name
    object.urn.downcase.underscore
  end
end
