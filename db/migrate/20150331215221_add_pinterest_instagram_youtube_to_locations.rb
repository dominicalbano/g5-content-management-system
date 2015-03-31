class AddPinterestInstagramYoutubeToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :pinterest_id, :string, :default => ""
    add_column :locations, :instagram_id, :string, :default => ""
    add_column :locations, :youtube_id, :string, :default => ""
  end
end
