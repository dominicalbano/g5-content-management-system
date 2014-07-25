class CorporateMapSetting
  def populated_states
    grouped_locations.map { |group| group[0] }
  end

  def state_location_counts
    Hash[*states_and_counts.flatten]
  end

  def value
    {
      "populated_states" => populated_states,
      "state_location_counts" => state_location_counts
    }
  end

private

  def grouped_locations
    Location.order("locations.state ASC").order("locations.city ASC").all.group_by(&:state)
  end

  def states_and_counts
    grouped_locations.map { |group| [group[0], group[1].size] }
  end
end
