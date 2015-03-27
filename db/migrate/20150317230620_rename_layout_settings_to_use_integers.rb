class RenameLayoutSettingsToUseIntegers < ActiveRecord::Migration
  def up
    ["row","column"].each do |layout|
      ["one","two","three","four","five","six"].each.with_index(1) do |count, idx|
        ["name","id"].each do |prop|
          settings = Setting.where("name LIKE ?", "#{layout}_#{count}_widget_#{prop}")
          new_name = "#{layout}_#{idx}_widget_#{prop}"
          settings.each do |setting|
            setting.update_attribute(:name, new_name)
          end
        end
      end
    end
    GardenWidgetUpdater.new.update_all(false, ['content-stripe','column'])
  end

  def down
    ["row","column"].each do |layout|
      ["one","two","three","four","five","six"].each.with_index(1) do |count, idx|
        ["name","id"].each do |prop|
          settings = Setting.where("name LIKE ?", "#{layout}_#{idx}_widget_#{prop}")
          new_name = "#{layout}_#{count}_widget_#{prop}"
          settings.each do |setting|
            setting.update_attribute(:name, new_name)
          end
        end
      end
    end
  end
end
