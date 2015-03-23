class AddSettingLocationNavigation < ActiveRecord::Migration
  def up
    Website.all.each do |website|
      setting = website.settings.find_or_create_by(name: "locations_navigation")
      setting.update_attributes!(value: LocationsNavigationSetting.new.value)
    end
  end

  def down
    Website.all.each do |website|
      website.settings.where(name: "locations_navigation").destroy_all
    end
  end
end
