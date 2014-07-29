class AddSettingCorporateMap < ActiveRecord::Migration
  def up
    Website.all.each do |website|
      setting = website.settings.find_or_create_by(name: "corporate_map")
      setting.update_attributes!(value: CorporateMapSetting.new.value)
    end
  end

  def down
    Website.all.each do |website|
      website.settings.where(name: "corporate_map").destroy_all
    end
  end
end
