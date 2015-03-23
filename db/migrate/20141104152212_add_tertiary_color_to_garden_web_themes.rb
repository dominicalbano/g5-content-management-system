class AddTertiaryColorToGardenWebThemes < ActiveRecord::Migration
  def change
    add_column :garden_web_themes, :tertiary_color, :string, default: "#ffffff"
  end
end
