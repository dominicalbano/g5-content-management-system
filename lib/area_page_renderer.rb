class AreaPageRenderer
  def initialize(locations, area)
    @locations = locations
    @area = area
  end

  def render
    "<div class='area_page map'>#{title + locations_markup + map}</div>"
  end

private

  def title
    "<h1>Locations in #{@area.upcase}</h1>"
  end

  def locations_markup
    "<div class='area_page_locations'>#{locations}</div>"
  end

  def locations
    @locations.inject("") do |html, location|
      html += location_markup(location)
    end
  end

  def location_addresses
    @locations.map do |location|
      [address_for(location), formatted_address_for(location)]
    end
  end

  def map
    ActionController::Base.new.render_to_string(
      partial: "area_pages/map",
      locals: { addresses: location_addresses }
    )
  end

  def location_markup(location)
    ActionController::Base.new.render_to_string(
      partial: "area_pages/location",
      locals: { location: location }
    )
  end

  def formatted_address_for(location)
    ActionController::Base.new.render_to_string(
      partial: "area_pages/location_map_address",
      locals: { location: location }
    )
  end

  def address_for(location)
    "#{location.street_address}, #{location.city}, " \
    "#{location.state} #{location.postal_code}"
  end
end
