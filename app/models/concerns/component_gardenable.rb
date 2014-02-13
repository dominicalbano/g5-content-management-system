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
      @microformats = microformats_parser.parse(garden_url,
        {"If-Modified-Since" => if_modified_since.to_s})
    rescue OpenURI::HTTPError => e
      if e.message.include?("304")
        @microformats || []
      else
        raise e
      end
    end

    def components_microformats
      if garden_microformats.respond_to?(:g5_components)
        garden_microformats.g5_components
      else
        []
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
