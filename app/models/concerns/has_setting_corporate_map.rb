module HasSettingCorporateMap
  extend ActiveSupport::Concern

  included do
    after_create :update_corporate_map_settings
  end

  def update_corporate_map_settings
    Website.all.map(&:update_corporate_map_setting)
  end

  def corporate_map_settings
    settings.where(name: "corporate_map")
  end

  def update_corporate_map_setting
    corporate_map_settings.each do |corporate_map_setting|
      corporate_map_setting.update_attribute(:value, CorporateMapSetting.new.value)
    end
  end
end
