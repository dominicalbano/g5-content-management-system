class AreaPageRenderer
  def initialize(locations, area)
    @locations = locations
    @area = area
  end

  def render
    "<div class='area-page map'>#{title + locations_markup + map + footer}</div>"
  end

private

  def title
    "<h1>Locations in #{formatted_area}</h1>"
  end

  def locations_markup
    "<div class='area-page-locations'>#{locations}</div>"
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

  def footer
    "<div class='area-page-footer'></div>"
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

  def formatted_area
    components = @area.split(",")
    components.last.upcase!
    components.join(",")
  end
end
