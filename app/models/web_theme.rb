class WebTheme < ActiveRecord::Base
  include HasManySettings

  belongs_to :garden_web_theme
  belongs_to :web_template
  has_one :website, through: :web_template

  delegate :website_id,
    to: :web_template, allow_nil: true

  delegate :name, :url, :thumbnail, :javascripts, :stylesheets,
    to: :garden_web_theme, allow_nil: true

  # prefix means access with `garden_web_theme_primary_color` not `primary_color`
  delegate :primary_color, :secondary_color, :tertiary_color,
    to: :garden_web_theme, allow_nil: true, prefix: true

  def display_colors
    { primary_color: primary_color,
      secondary_color: secondary_color,
      tertiary_color: tertiary_color }
  end

  def primary_color
    if custom_colors? && custom_primary_color
      custom_primary_color
    else
      garden_web_theme_primary_color
    end
  end

  def primary_color=(value)
    self.custom_primary_color = value
  end

  def secondary_color
    if custom_colors? && custom_secondary_color
      custom_secondary_color
    else
      garden_web_theme_secondary_color
    end
  end

  def secondary_color=(value)
    self.custom_secondary_color = value
  end

  def tertiary_color
    if custom_colors? && custom_tertiary_color
      custom_tertiary_color
    else
      garden_web_theme_tertiary_color
    end
  end

  def tertiary_color=(value)
    self.custom_tertiary_color = value
  end
end
