class LocationsNavigationSetting
  def grouped_locations
    Location.order("locations.state ASC").order("locations.city ASC").all.group_by(&:state)
  end

  def value
    setting = {}
    grouped_locations.map do |state_name, locations|
      state_setting = {}
      locations.each do |location|
        state_setting[location.name] = "/" + location.website.try(:single_domain_location_path).to_s
      end
      setting[state_name] = state_setting
    end
    setting
  end
end
