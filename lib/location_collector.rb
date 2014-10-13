class LocationCollector
  def initialize(params)
    @params = params
  end

  def collect
    return locations_by_neighborhood if @params[:neighborhood]
    return locations_by_city if @params[:city]
    locations_by_state
  end

private

  def locations_by_neighborhood
    locations_by_city.select do |location|
      location.neighborhood_slug == @params[:neighborhood]
    end
  end

  def locations_by_city
    locations_by_state.select { |location| location.city_slug == @params[:city] }
  end

  def locations_by_state
    Location.live.all.select { |location| location.state_slug == @params[:state] }
  end
end
