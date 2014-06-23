module AfterUpdateSetSettingLocationsNavigation
  extend ActiveSupport::Concern

  included do
    after_create :update_locations_navigation_settings
    after_update :update_locations_navigation_settings, if: :should_update_locations_navigation_settings?
  end

  private

  def should_update_locations_navigation_settings?
    state_changed? || city_changed? || name_changed?
  end

  def update_locations_navigation_settings
    Website.all.map(&:update_locations_navigation_setting)
  end
end
