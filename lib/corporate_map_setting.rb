class CorporateMapSetting

  def value
    {
      "populated_states" => populated_states.to_json,
      "state_location_counts" => state_location_counts.to_json,
      "primary_color" => color_finder.primary_color.to_json,
      "hover_color" => color_finder.hover_color.to_json
    }
  end

  private

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
    Location.where(corporate: true).first
  end

  def color_finder
    @color_finder ||= ColorFinder.new(corporate_location)
  end
end
