class CreateGardenWebThemes < ActiveRecord::Migration
  def change
    create_table :garden_web_themes do |t|
      t.string :name
      t.string :slug
      t.string :url
      t.string :thumbnail
      t.text :javascripts
      t.text :stylesheets
      t.string :primary_color
      t.string :secondary_color
      t.string   "tertiary_color", default: "#ffffff"

      t.timestamps
    end
  end
end
