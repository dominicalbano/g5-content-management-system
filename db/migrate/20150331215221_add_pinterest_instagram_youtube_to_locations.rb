class AddPinterestInstagramYoutubeToLocations < ActiveRecord::Migration
  def change
    add_column :location, :pinterest_id, :string
    add_column :location, :instagram_id, :string
    add_column :location, :thumbnail_id, :string

    ClientReader.new(ENV["G5_CLIENT_UID"]).perform
  end
end
