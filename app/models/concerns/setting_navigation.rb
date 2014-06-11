module SettingNavigation
  extend ActiveSupport::Concern

  included do
    before_update :update_widget_navigation_setting, if: :widget_navigation_setting_updated?
    after_update :update_widget_navigation_settings, if: :website_navigation_setting?
    scope :navigation, -> { where(name: "navigation") }
  end

  def website_navigation_setting?
    owner_type == "Website" && name == "navigation"
  end

  def widget_navigation_setting_updated?
    owner_type == "Widget" && name == "navigation" && value.is_a?(Hash)
  end

  def website_navigation_setting
    setting_website.settings.navigation.first
  end

  def widget_navigation_settings
    setting_website.widget_settings.navigation
  end

  # should be called on website setting, not widget setting
  def update_widget_navigation_settings
    widget_navigation_settings.map(&:update_widget_navigation_setting).map(&:save)
  end

  # should be called on widget setting, not website setting
  def update_widget_navigation_setting
    if value
      self.value = create_new_value(website_navigation_setting.value, value)
    else
      self.value = website_navigation_setting.value
    end
    self
  end

  def create_new_value(website_value, widget_value)
    new_value = {}
    website_value.each_pair do |key, website_partial_value|
      widget_partial_value = widget_value[key]
      # widget_partial_value could be false, so can't check presence
      unless widget_partial_value.nil?
        website_partial_value["display"] = widget_partial_value["display"]
      end
      new_value[key] = HashWithToLiquid[website_partial_value]
    end
    new_value
  end

  def setting_website
    website || NavigationSettingWebsiteFinder.new(self).find
  end
end
