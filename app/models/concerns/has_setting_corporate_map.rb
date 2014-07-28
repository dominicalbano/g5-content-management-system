module HasSettingCorporateMap
  extend ActiveSupport::Concern

  included do
    after_create :update_corporate_map_settings
  end

  def update_corporate_map_settings
    Website.all.map(&:update_corporate_map_setting)
  end

  def update_corporate_map_setting
    settings.where(name: "corporate_map").each do |setting|
      setting.update(value: CorporateMapSetting.new.value)
    end
  end
end
