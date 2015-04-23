class LocationCollector
  def initialize(params)
    write_to_loggers("initializing LocationCollector with: #{params}")
    @params = params
  end

  def collect
    write_to_loggers("params passed to LocationCollector: #{@params}")
    write_to_loggers("trying locations_by_neighborhood if params[:neighborhood]")
    return locations_by_neighborhood if @params[:neighborhood]
    write_to_loggers("trying locations_by_city if params[:city]")
    return locations_by_city if @params[:city]
    write_to_loggers("last option of locations_by_state")
    locations_by_state
  end

private

  def locations_by_neighborhood
    locations_by_city.select do |location|
      location.neighborhood_slug == @params[:neighborhood]
    end
  end

  def locations_by_city
    write_to_loggers("trying to get locations by city from locations_by_state")
    locations_by_state.select { |location| location.city_slug == @params[:city] }
  end

  def locations_by_state
    write_to_loggers("getting Location.live.all.select by state: #{@params.to_s}")
    locations = Location.for_area_pages.all.select { |location| location.state_slug == @params[:state] }
    write_to_loggers("got locations: #{locations.map(&:name)}")
    locations
  end
end
