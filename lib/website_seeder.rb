class WebsiteSeeder
  attr_reader :location, :instructions, :website

  def initialize(location, instructions=nil)
    @location = location
    @client = Client.first
    @instructions = instructions || @client.website_defaults
    @website = location.create_website
  end

  def seed
    create_general_settings
    create_services_settings
    create_website_template(website, instructions["website_template"])
    create_web_home_template(website, instructions["web_home_template"])
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
    {
      "client_urn"                => client_services.client_urn,
      "client_url"                => client_services.client_url,
      "client_location_urns"      => client_services.client_location_urns,
      "client_location_urls"      => client_services.client_location_urls,
      "location_urn"              => location.urn,
      "location_url"              => location.domain,
      "location_street_address"   => location.street_address,
      "location_city"             => location.city,
      "location_state"            => location.state,
      "location_postal_code"      => location.postal_code,
      "phone_number"              => location.phone_number,
      "row_widget_garden_widgets" => RowWidgetGardenWidgetsSetting.new.value,
      "locations_navigation"      => LocationsNavigationSetting.new.value
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
    if website && instruction
      web_home_template = website.create_web_home_template(web_template_params(instruction))
      create_drop_targets(web_home_template, instruction["drop_targets"])
    end
  end

  def create_web_page_templates(website, instructions)
    if website && instructions
      instructions.each do |instruction|
        web_page_template = website.web_page_templates.create(web_template_params(instruction))
        create_drop_targets(web_page_template, instruction["drop_targets"])
      end
    end
  end

  def create_drop_targets(web_template, instructions)
    if web_template && instructions
      instructions.each do |instruction|
        drop_target = web_template.drop_targets.create(drop_target_params(instruction))
        create_widgets(drop_target, instruction["widgets"])
      end
    end
  end

  def create_widgets(drop_target, instructions)
    if drop_target && instructions
      instructions.each do |instruction|
        widget = drop_target.widgets.create(widget_params(instruction))
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
    garden_web_layout = GardenWebLayout.find_by_slug(instructions["slug"])
    instructions = instructions.dup
    instructions["garden_web_layout_id"] = garden_web_layout.try(:id)
    ActionController::Parameters.new(instructions).permit(:garden_web_layout_id)
  end

  def theme_params(instructions)
    garden_web_theme = GardenWebTheme.find_by_slug(instructions["slug"])
    instructions = instructions.dup
    instructions["garden_web_theme_id"] = garden_web_theme.try(:id)
    ActionController::Parameters.new(instructions).permit(:garden_web_theme_id)
  end

  def drop_target_params(instructions)
    ActionController::Parameters.new(instructions).permit(:html_id)
  end

  def widget_params(instructions)
    garden_widget = GardenWidget.find_by_slug(instructions["slug"])
    instructions = instructions.dup
    instructions["garden_widget_id"] = garden_widget.try(:id)
    ActionController::Parameters.new(instructions).permit(:garden_widget_id)
  end
end
