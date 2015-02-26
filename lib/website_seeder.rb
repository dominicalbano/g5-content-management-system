class WebsiteSeeder < ModelSeeder
  attr_reader :location, :instructions, :website

  def initialize(location, instructions=nil)
    @location = location
    @client = Client.first
    @instructions = instructions || @client.website_defaults
    @website = location.create_website
  end

  def seed
    Rails.logger.debug("Performing Seed")
    create_general_settings
    create_services_settings
    create_website_template(@website, @instructions["website_template"])
    create_web_home_template(@website, @instructions["web_home_template"])
    create_web_page_templates(@website, @instructions["web_page_templates"])
    @website
  end

  def client_services
    @client_services ||= ClientServices.new
  end

  def create_general_settings
    Rails.logger.debug("Creating general settings")
    general_settings.each { |key, value| create_setting!(key, value) }
  end

  def general_settings
    client_settings.merge(location_settings).merge(other_settings)
  end

  def client_settings
    {
      "client_urn"           => client_services.client_urn,
      "client_url"           => client_services.client_url,
      "client_location_urns" => client_services.client_location_urns,
      "client_location_urls" => client_services.client_location_urls
    }
  end

  def location_settings
    {
      "location_urn"            => location.urn,
      "location_url"            => location.domain,
      "location_street_address" => location.street_address,
      "location_city"           => location.city,
      "location_state"          => location.state,
      "location_postal_code"    => location.postal_code,
      "phone_number"            => location.phone_number
    }
  end

  def other_settings
    {
      "row_widget_garden_widgets" => RowWidgetGardenWidgetsSetting.new.value,
      "locations_navigation"      => LocationsNavigationSetting.new.value,
      "corporate_map"             => CorporateMapSetting.new.value
    }
  end

  def create_services_settings
    Rails.logger.debug("Creating services settings")
    ClientServices::SERVICES.each do |service|
      %w(urn url).each do |suffix|
        setting_name = [service, suffix].join("_")
        create_setting!(setting_name, client_services.public_send(setting_name.to_sym))
      end
    end
  end

  def create_website_template(website, instruction)
    Rails.logger.debug("Creating website template")
    if website && instruction
      website_template = website.create_website_template(web_template_params(instruction))
      web_layout = website_template.create_web_layout(layout_params(instruction["web_layout"]))
      web_theme = website_template.create_web_theme(theme_params(instruction["web_theme"]))
      DropTargetSeeder.new(website, website_template, instruction["drop_targets"]).seed
    end
  end

  def create_web_home_template(website, instruction)
    Rails.logger.debug("Creating web home template")
    WebPageTemplateSeeder.new(website, instruction, true).seed
  end

  def create_web_page_templates(website, instructions)
    Rails.logger.debug("Creating web page templates from instructions")
    if website && instructions
      instructions.each do |instruction|
        WebPageTemplateSeeder.new(website, instruction, false).seed
      end
    end
  end

  private

  def create_setting!(name, value)
    website.settings.find_or_create_by(name: name) do |setting|
      setting.value = value
    end
  end

  def layout_params(instructions)
    params_for(GardenWebLayout, instructions, :garden_web_layout_id)
  end

  def theme_params(instructions)
    params_for(GardenWebTheme, instructions, :garden_web_theme_id)
  end
end

