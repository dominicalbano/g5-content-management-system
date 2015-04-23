class AddLayoutsToGardenWebThemes < ActiveRecord::Migration
  def change
    add_column :garden_web_themes, :layouts, :text
  end
end
