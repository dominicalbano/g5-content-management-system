class AddCustomTertiaryColorToWebThemes < ActiveRecord::Migration
  def change
    add_column :web_themes, :custom_tertiary_color, :string, default: "#fff"
  end
end
