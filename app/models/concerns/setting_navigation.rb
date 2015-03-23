module SettingNavigation extend ActiveSupport::Concern

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
    setting_website.widget_settings.select {|widget| widget.name == "navigation"}
  end

  # should be called on website setting, not widget setting
  def update_widget_navigation_settings
    return unless valid_setting?

    widget_navigation_settings.map(&:update_widget_navigation_setting).map(&:save)
  end

  # should be called on widget setting, not website setting
  def update_widget_navigation_setting
    return unless valid_setting?

    if value
      self.value = create_new_value(website_navigation_setting.value, value)
    else
      self.value = website_navigation_setting.value
    end
    self
  end

  def create_new_value(website_value, widget_value)
    website_value.deep_merge!(widget_value)
    website_value.keys.each do |key|
      website_value[key]["sub_nav"] = "true" if show_sub_nav?(website_value[key])
    end
    website_value
  end
  
  def show_sub_nav?(website_value)
    website_value.fetch("child_templates",[]).any? {|child| child[1]["display"] == "true"}
  end

  def orphaned_drop_target?
    owner.kind_of?(Widget) && owner.drop_target_id.present? && owner.drop_target.blank?
  end

  def valid_setting?
    setting_website && !orphaned_drop_target?
  end

  def setting_website
    website ||= WebsiteFinder::Setting.new(self).find
  end

end

