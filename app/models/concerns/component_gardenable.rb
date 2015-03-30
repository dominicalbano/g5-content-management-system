module ComponentGardenable
  extend ActiveSupport::Concern

  module ClassMethods
    def set_garden_url(garden_url)
      @garden_url = garden_url
    end

    def garden_url
      @garden_url
    end

    def component_url(component_name)
      "#{garden_url}/components/#{component_name}"
    end

    def microformats_parser
      @microformats_parser ||= Microformats2::Parser.new
    end

    def if_modified_since
      microformats_parser.http_headers["last-modified"]
    end

    def garden_microformats
      # Passing these options breaks since upgrading to Ruby 2.1.1
      # {"If-Modified-Since" => if_modified_since.to_s}
      @microformats = microformats_parser.parse(garden_url, {})
    rescue OpenURI::HTTPError => e
      if e.message.include?("304")
        @microformats || []
      else
        Rails.logger.debug("error: #{e}")
        raise e
      end
    end

    def components_microformats
      garden_data = garden_microformats
      if garden_data.respond_to?(:g5_components) && garden_data.g5_components
        reject_untargeted_private(garden_data.g5_components.dup)
      else
        []
      end
    end

    def reject_untargeted_private(g5_components)
      g5_components.reject! do |component|
        not_targeted?(component)
      end
      g5_components
    end

    def not_targeted?(component)
      if component.respond_to?(:g5_targets)
        !component.g5_targets.map(&:to_s).include? MAIN_APP_UID
      end
    end
  end

  def component_microformat
    component = Microformats2.parse(url).first
    raise "No h-g5-component found at url: #{url}" unless component
    component
  rescue OpenURI::HTTPError => e
    Rails.logger.warn e.message
  end
end

