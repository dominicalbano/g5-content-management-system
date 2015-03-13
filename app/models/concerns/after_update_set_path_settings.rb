module AfterUpdateSetPathSettings
  extend ActiveSupport::Concern

  included do
    after_update :update_settings, if: :should_update_location_paths?
  end

  private

  def should_update_location_paths?
    city_changed? || state_changed?
  end

  def update_settings
    update_cta_settings
    update_nav_settings
  end

  def update_cta_settings
    CtaSettingsUpdater.new(self).update
  end

  def update_nav_settings
    website.try(:update_navigation_settings)
  end
end
