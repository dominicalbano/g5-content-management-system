class LocationCollector
  LOGGERS = [Resque.logger, Rails.logger] unless defined? LOGGERS
  def initialize(params)
    LOGGERS.each {|logger| logger.info("initializing LocationCollector with: #{params}")}
    @params = params
  end

  def collect
    LOGGERS.each {|logger| logger.info("params passed to LocationCollector: #{@params}")}
    LOGGERS.each {|logger| logger.info("trying locations_by_neighborhood if params[:neighborhood]")}
    return locations_by_neighborhood if @params[:neighborhood]
    LOGGERS.each {|logger| logger.info("trying locations_by_city if params[:city]")}
    return locations_by_city if @params[:city]
    LOGGERS.each {|logger| logger.info("last option of locations_by_state")}
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
    Location.for_area_pages.all.select { |location| location.state_slug == @params[:state] }
  end
end
