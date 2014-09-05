module AfterUpdateSetSettingCta
  extend ActiveSupport::Concern

  included do
    after_update :update_cta_settings, if: :should_update_cta_settings?
  end

  private

  def should_update_cta_settings?
    city_changed? || state_changed?
  end

  def update_cta_settings
    CtaSettingsUpdater.new.update
  end
end
