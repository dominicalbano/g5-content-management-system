class AddFieldsToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :go_squared_client_id, :string, :default => ""
    add_column :locations, :go_squared_site_token, :string, :default => ""
    add_column :locations, :ga_tracking_id, :string, :default => ""
    add_column :locations, :ga_profile_id, :string, :default => ""
    add_column :locations, :facebook_id, :string, :default => ""
    add_column :locations, :twitter_id, :string, :default => ""
    add_column :locations, :yelp_id, :string, :default => ""
  end
end
