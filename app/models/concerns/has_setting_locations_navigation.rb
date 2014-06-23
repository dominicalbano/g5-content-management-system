module HasSettingLocationsNavigation
  extend ActiveSupport::Concern

  included do
    after_create :update_locations_navigation_settings
  end

  def update_locations_navigation_settings
    Website.all.map(&:update_locations_navigation_setting)
  end

  def locations_navigation_settings
    settings.where(name: "locations_navigation")
  end

  def update_locations_navigation_setting
    locations_navigation_settings.each do |locations_navigation_setting|
      locations_navigation_setting.update_attribute(:value,
        LocationsNavigationSetting.new.value)
    end
  end
end
