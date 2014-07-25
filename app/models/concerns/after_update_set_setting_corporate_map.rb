module AfterUpdateSetSettingCorporateMap
  extend ActiveSupport::Concern

  included do
    after_create :update_corporate_map_settings
    after_update :update_corporate_map_settings, if: :should_update_corporate_map_settings?
  end

  private

  def should_update_corporate_map_settings?
    state_changed?
  end

  def update_corporate_map_settings
    Website.all.map(&:update_corporate_map_setting)
  end
end
