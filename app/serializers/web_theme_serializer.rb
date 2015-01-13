class WebThemeSerializer < ActiveModel::Serializer
  attributes  :id,
              :garden_web_theme_id,
              :website_template_id,
              :name,
              :thumbnail,
              :url,
              :custom_colors,
              :primary_color,
              :secondary_color,
              :tertiary_color,
              :custom_fonts,
              :primary_font,
              :secondary_font

  def website_template_id
    object.web_template_id
  end
end
