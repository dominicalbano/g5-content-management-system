module LiquidParameters
  extend ActiveSupport::Concern

  def extend_liquid_methods
    liquid_parameters.each do |key, value|
      define_singleton_method(key) { liquid_parameters[key] }
    end
  end

  def liquid_parameters
    template = get_web_template
    return {} if template.blank?

    client = template.client
    location = template.owner
    {
      "web_template_name"         => template.name,
      "website_urn"               => location.website.urn,
      "location_uid"              => location.uid,
      "location_urn"              => location.urn,
      "location_domain"           => location.domain,
      "location_corporate"        => location.corporate,
      "location_name"             => location.name,
      "location_city"             => location.city,
      "location_state"            => location.state,
      "location_street_address"   => location.street_address,
      "location_neighborhood"     => location.neighborhood,
      "location_postal_code"      => location.postal_code,
      "location_phone_number"     => location.phone_number,
      "location_floor_plans"      => location.floor_plans,
      "location_primary_amenity"  => location.primary_amenity,
      "location_qualifier"        => location.qualifier,
      "location_primary_landmark" => location.primary_landmark,
      "client_name"               => client.name,
      "client_domain"             => client.domain,
      "client_vertical"           => client.vertical,
      "client_urn"                => client.urn,
      "client_uid"                => client.uid,
      "client_type"               => client.type
    }
  end

  def get_liquid_parameter(key)
    return liquid_parameters[key] if liquid_parameters.has_key?(key)
  end

  # override to extend behavior
  def get_web_template(object=self)
    return object if object.is_a?(WebTemplate)
    object.try(:web_template)
  end
end