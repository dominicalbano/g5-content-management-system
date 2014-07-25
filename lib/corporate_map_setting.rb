class CorporateMapSetting
  DEFAULT_PRIMARY_COLOR = "#222222"
  DEFAULT_HOVER_COLOR = "#333333"

  def value
    {
      "populated_states" => populated_states.to_json,
      "state_location_counts" => state_location_counts.to_json,
      "primary_color" => primary_color.to_json,
      "hover_color" => hover_color.to_json
    }
  end

private

  def primary_color
    corporate_location_primary_color || DEFAULT_PRIMARY_COLOR
  end

  def hover_color
    calculate_hover_color(corporate_location_primary_color) || DEFAULT_HOVER_COLOR
  end

  def corporate_location_primary_color
    return unless corporate_location
    web_theme.custom_primary_color|| web_theme.garden_web_theme.primary_color
  end

  def calculate_hover_color(base_color)
    return unless base_color
    "#%02x%02x%02x" % lighten_hex(base_color.gsub("#",""))
  end

  def lighten_hex(hex, amount=0.17)
    hex.scan(/../).map(&:hex).map { |color| [(color.to_i + 255 * amount).round, 255].min }
  end

  def populated_states
    grouped_locations.map { |group| group[0] }
  end

  def state_location_counts
    Hash[*states_and_counts.flatten]
  end

  def grouped_locations
    Location.order("locations.state ASC").order("locations.city ASC").all.group_by(&:state)
  end

  def states_and_counts
    grouped_locations.map { |group| [group[0], group[1].size] }
  end

  def corporate_location
    @corporate_location ||= Location.where(corporate: true).first
  end

  def web_theme
    return unless corporate_location
    @web_theme ||= corporate_location.website.website_template.web_theme
  end
end
