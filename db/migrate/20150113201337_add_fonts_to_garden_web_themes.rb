class AddFontsToGardenWebThemes < ActiveRecord::Migration
  def change
    add_column :garden_web_themes, :primary_font, :string, :default => 'PT Sans'
    add_column :garden_web_themes, :secondary_font, :string, :default => 'Georgia'
  end
end
