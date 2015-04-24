module StaticWebsite
  module Compiler
    class AreaPages
      attr_accessor :pages

      def initialize(base_path, websites)
        LOGGERS.each {|logger| logger.debug("init Compiler::AreaPages w/ (base_path, websites): #{base_path} #{websites}")}
        @base_path = base_path
        @websites = websites
        @pages = []
        @client = Client.first
      end

      def compile
        states.each do |state|
          LOGGERS.each {|logger| logger.debug("compiling state #{state.to_s}")}
          path = "#{vertical}/#{state}"
          compile_area_page(path, params(state))
          LOGGERS.each {|logger| logger.debug("calling compile_cities_for_state(#{state.to_s})")}
          compile_cities_for_state(state)
        end
        pages
      end

    private

      def compile_cities_for_state(state)
        cities_for_state(state).each do |city|
          LOGGERS.each {|logger| logger.debug("compiling city #{city.to_s}")}
          compile_area_page("#{vertical}/#{state}/#{city}", params(state, city))
          LOGGERS.each {|logger| logger.debug("compiling neighborhoods for #{city.to_s} and #{state.to_s}")}
          compile_neighborhoods_for_city_and_state(city, state)
        end
      end

      def compile_neighborhoods_for_city_and_state(city, state)
        neighborhoods_for_city(city).each do |neighborhood|
          path = "#{vertical}/#{state}/#{city}/#{neighborhood}"
          compile_area_page(path, params(state, city, neighborhood))
        end
      end

      def compile_area_page(path, params)
        LOGGERS.each {|logger| logger.debug("calling AreaPage.new().compile")}
        pages << AreaPage.new(@base_path, path, params).compile.sub("/index.html",'')
      end

      def vertical
        @client.vertical.downcase
      end

      def states
        @websites.map { |website| website.owner.state_slug }.uniq
      end

      def cities_for_state(state)
        websites_for_state(state).map { |website| website.owner.city_slug }.uniq
      end

      def neighborhoods_for_city(city)
        websites_for_city(city).map { |website| website.owner.neighborhood_slug }.uniq
      end

      def websites_for_state(state)
        @websites.select { |website| website.owner.state_slug == state }
      end

      def websites_for_city(city)
        @websites.select { |website| website.owner.city_slug == city }
      end

      def params(state, city=nil, neighborhood=nil)
        { state: state, city: city, neighborhood: neighborhood }
      end
    end
  end
end
