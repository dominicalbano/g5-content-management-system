class AddThumbUrlToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :thumb_url, :string
  end
end
