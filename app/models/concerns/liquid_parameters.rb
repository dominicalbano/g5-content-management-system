module LiquidParameters
  extend ActiveSupport::Concern

  def extend_liquid_methods
    liquid_parameters.each do |key, value|
      define_singleton_method(key) { liquid_parameters[key] }
    end
  end

  def liquid_parameters
    @liquid_template = get_web_template
    return {} if @liquid_template.blank?
    get_liquid_parameters.reduce({}, :merge)
  end

  def get_liquid_parameter(key)
    return liquid_parameters[key] if liquid_parameters.has_key?(key)
  end

  # override to extend behavior
  def get_web_template(object=self)
    return object if object.is_a?(WebTemplate)
    object.try(:web_template)
  end

  private

  def liquid_location
    @location ||= @liquid_template.website.owner
  end

  def liquid_client
    @client ||= @liquid_template.client
  end

  def get_liquid_parameters
    [page_liquid, location_liquid, address_liquid, social_liquid, client_liquid, theme_liquid]
  end

  def page_liquid
    {
      "page_name"                 => @liquid_template.name,
      "page_slug"                 => @liquid_template.slug,
      "page_created"              => @liquid_template.created_at.to_s.gsub(' UTC',''),
      "page_updated"              => @liquid_template.updated_at.to_s.gsub(' UTC','')
    }
  end

  def location_liquid
    {
      "website_urn"               => liquid_location.website.urn,
      "location_uid"              => liquid_location.uid,
      "location_urn"              => liquid_location.urn,
      "location_domain"           => liquid_location.domain,
      "location_corporate"        => liquid_location.corporate ? 'true' : 'false',
      "location_name"             => liquid_location.name,
      "location_phone_number"     => liquid_location.phone_number,
      "location_office_hours"     => liquid_location.office_hours,
      "location_access_hours"     => liquid_location.access_hours,
      "location_floor_plans"      => liquid_location.floor_plans,
      "location_primary_amenity"  => liquid_location.primary_amenity,
      "location_qualifier"        => liquid_location.qualifier,
      "location_primary_landmark" => liquid_location.primary_landmark
    }
  end

  def address_liquid
    {
      "location_city"             => liquid_location.city,
      "location_state"            => liquid_location.state,
      "location_name_slug"        => liquid_location.name.parameterize,
      "location_city_slug"        => liquid_location.city.parameterize,
      "location_state_slug"       => liquid_location.state.parameterize,
      "location_street_address"   => liquid_location.street_address,
      "location_neighborhood"     => liquid_location.neighborhood,
      "location_postal_code"      => liquid_location.postal_code
    }
  end

  def social_liquid
    {
      "location_go_squared_id"    => liquid_location.go_squared_client_id,
      "location_go_squared_tag"   => liquid_location.go_squared_site_token,
      "location_ga_tracking_id"   => liquid_location.ga_tracking_id,
      "location_ga_profile_id"    => liquid_location.ga_profile_id,
      "location_facebook_id"      => liquid_location.facebook_id,
      "location_twitter_id"       => liquid_location.twitter_id,
      "location_yelp_id"          => liquid_location.yelp_id,
      "location_pinterest_id"     => liquid_location.pinterest_id,
      "location_instagram_id"     => liquid_location.instagram_id,
      "location_youtube_id"       => liquid_location.youtube_id
    }
  end

  def client_liquid
    {
      "client_name"               => liquid_client.name,
      "client_name_slug"          => liquid_client.name.parameterize,
      "client_domain"             => liquid_client.domain,
      "client_vertical"           => liquid_client.vertical,
      "client_urn"                => liquid_client.urn,
      "client_uid"                => liquid_client.uid,
      "client_type"               => liquid_client.type,
      "client_go_squared_id"      => liquid_client.go_squared_client_id,
      "client_go_squared_tag"     => liquid_client.go_squared_tag,
      "client_cls_url"            => liquid_client.cls_url,
      "client_cxm_url"            => liquid_client.cxm_url,
      "client_dsh_url"            => liquid_client.dsh_url,
      "client_cpas_url"           => liquid_client.cpas_url,
      "client_cpns_url"           => liquid_client.cpns_url,
      "client_nae_url"            => liquid_client.nae_url,
      "client_vls_url"            => liquid_client.vls_url
    }
  end

  def theme_liquid
    liquid_web_template = @liquid_template.website_template
    liquid_web_theme = liquid_web_template.try(:web_theme)
    {
      "theme_name"                => liquid_web_theme.try(:name),
      "theme_slug"                => liquid_web_theme.try(:garden_web_theme).try(:slug),
      "theme_primary_color"       => liquid_web_theme.try(:primary_color),
      "theme_secondary_color"     => liquid_web_theme.try(:secondary_color),
      "theme_tertiary_color"      => liquid_web_theme.try(:tertiary_color),
      "theme_primary_font"        => liquid_web_theme.try(:primary_font),
      "theme_secondary_font"      => liquid_web_theme.try(:secondary_font)
    }
  end
end