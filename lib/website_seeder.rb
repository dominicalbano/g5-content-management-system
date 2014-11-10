class WebsiteSeeder
  attr_reader :location, :instructions, :website

  def initialize(location, instructions=nil)
    @location = location
    @client = Client.first
    @instructions = instructions || @client.website_defaults
    @website = location.create_website
  end

  def seed
    Rails.logger.info("Performing Seed")
    Rails.logger.info("Creating general settings")
    create_general_settings
    Rails.logger.info("Creating services settings")
    create_services_settings
    Rails.logger.info("Creating website template")
    create_website_template(website, instructions["website_template"])
    Rails.logger.info("Creating web home template")
    create_web_home_template(website, instructions["web_home_template"])
    Rails.logger.info("Creating web page templates")
    create_web_page_templates(website, instructions["web_page_templates"])

    website
  end

  def client_services
    @client_services ||= ClientServices.new
  end

  def create_general_settings
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
    ClientServices::SERVICES.each do |service|
      %w(urn url).each do |suffix|
        setting_name = [service, suffix].join("_")
        create_setting!(setting_name, client_services.public_send(setting_name.to_sym))
      end
    end
  end

  def create_website_template(website, instruction)
    if website && instruction
      website_template = website.create_website_template(web_template_params(instruction))
      web_layout = website_template.create_web_layout(layout_params(instruction["web_layout"]))
      web_theme = website_template.create_web_theme(theme_params(instruction["web_theme"]))
      create_drop_targets(website_template, instruction["drop_targets"])
    end
  end

  def create_web_home_template(website, instruction)
    Rails.logger.info("Creating web home template from instructions")
    if website && instruction
      web_home_template = website.create_web_home_template(web_template_params(instruction))
      create_drop_targets(web_home_template, instruction["drop_targets"])
    end
  end

  def create_web_page_templates(website, instructions)
    Rails.logger.info("Creating web page templates from instructions")
    if website && instructions
      instructions.each do |instruction|
        web_page_template = website.web_page_templates.create(web_template_params(instruction))
        create_drop_targets(web_page_template, instruction["drop_targets"])
      end
    end
  end

  def create_drop_targets(web_template, instructions)
    Rails.logger.info("Creating drop targets from instructions")
    if web_template && instructions
      instructions.each do |instruction|
        drop_target = web_template.drop_targets.create(drop_target_params(instruction))
        create_widgets(drop_target, instruction["widgets"])
      end
    end
  end

  def create_widgets(drop_target, instructions)
    Rails.logger.info("Creating widgets from instructions")
    if drop_target && instructions
      instructions.each do |instruction|
        widget = drop_target.widgets.create(widget_params(instruction))
        Rails.logger.info("Widget errors: #{widget.errors.inspect}") unless widget.valid?
        set_default_widget_settings(widget, instruction["settings"])
      end
    end
  end

  def set_default_widget_settings(widget, instruction)
    instruction.try(:each) do |setting|
      set_default_widget_setting(widget, setting)
    end
  end

  private

  def set_default_widget_setting(widget, setting)
    if widget_setting = widget.settings.find_by_name(setting["name"])
      widget_setting.update_attributes(setting)
    end
  end

  def create_setting!(name, value)
    website.settings.find_or_create_by(name: name) do |setting|
      setting.value = value
    end
  end

  def web_template_params(instructions)
    ActionController::Parameters.new(instructions).permit(:name, :title)
  end

  def layout_params(instructions)
    params_for(GardenWebLayout, instructions, :garden_web_layout_id)
  end

  def theme_params(instructions)
    params_for(GardenWebTheme, instructions, :garden_web_theme_id)
  end

  def drop_target_params(instructions)
    ActionController::Parameters.new(instructions).permit(:html_id)
  end

  def widget_params(instructions)
    params_for(GardenWidget, instructions, :garden_widget_id)
  end

  def params_for(model, instructions, parameter)
    widget = model.find_by_slug(instructions["slug"])
    instructions = instructions.dup
    instructions[parameter.to_s] = widget.try(:id)
    ActionController::Parameters.new(instructions).permit(parameter)
  end
end

