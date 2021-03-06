class SetsSettingWebsiteId < ActiveRecord::Migration
  def up
    Setting.for_no_website.each do |setting|
      setting.website = WebsiteFinder::Setting.new(setting).find
      setting.save
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

