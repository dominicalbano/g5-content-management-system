module StaticWebsite
  module Compiler
    class AreaPages
      def initialize(base_path, websites)
        @base_path = base_path
        @websites = websites
      end

      def compile
        states.each do |state|
          LOGGERS.each {|logger| logger.info("compiling state #{state}")}
          compile_area_page(state, params(state))
          compile_cities_for(state)
        end
      end

    private

      def compile_cities_for(state)
        cities_for(state).each do |city|
          compile_area_page("#{state}/#{city}", params(state, city))
          compile_neighborhoods_for(city, state)
        end
      end

      def compile_neighborhoods_for(city, state)
        neighborhoods_for(city).each do |neighborhood|
          path = "#{state}/#{city}/#{neighborhood}"
          compile_area_page(path, params(state, city, neighborhood))
        end
      end

      def compile_area_page(path, params)
        AreaPage.new(@base_path, path, params).compile
      end

      def states
        @websites.map { |website| website.owner.state_slug }.uniq
      end

      def cities_for(state)
        websites_for_state(state).map { |website| website.owner.city_slug }.uniq
      end

      def neighborhoods_for(city)
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
