class LocationCollector
  LOGGERS = [Resque.logger, Rails.logger] unless defined? LOGGERS
  def initialize(params)
    LOGGERS.each {|logger| logger.debug("initializing LocationCollector with: #{params}")}
    @params = params
  end

  def collect
    LOGGERS.each {|logger| logger.debug("params passed to LocationCollector: #{@params}")}
    LOGGERS.each {|logger| logger.debug("trying locations_by_neighborhood if params[:neighborhood]")}
    return locations_by_neighborhood if @params[:neighborhood]
    LOGGERS.each {|logger| logger.debug("trying locations_by_city if params[:city]")}
    return locations_by_city if @params[:city]
    LOGGERS.each {|logger| logger.debug("last option of locations_by_state")}
    locations_by_state
  end

private

  def locations_by_neighborhood
    locations_by_city.select do |location|
      location.neighborhood_slug == @params[:neighborhood]
    end
  end

  def locations_by_city
    LOGGERS.each {|logger| logger.debug("trying to get locations by city from locations_by_state")}
    locations_by_state.select { |location| location.city_slug == @params[:city] }
  end

  def locations_by_state
    LOGGERS.each {|logger| logger.debug("getting Location.live.all.select by state: #{@params.to_s}")}
    locations = Location.live.all.select { |location| location.state_slug == @params[:state] }
    LOGGERS.each {|logger| logger.debug("got locations: #{locations.map(&:name)}")}
    locations
  end
end
