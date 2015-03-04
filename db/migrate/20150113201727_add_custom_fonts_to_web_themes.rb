class AddCustomFontsToWebThemes < ActiveRecord::Migration
  def change
    add_column :web_themes, :custom_fonts, :boolean, default: false
    add_column :web_themes, :custom_primary_font, :string, default: "PT Sans"
    add_column :web_themes, :custom_secondary_font, :string, default: "Georgia"
  end
end
