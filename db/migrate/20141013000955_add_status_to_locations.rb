class AddStatusToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :status, :string, default: "New"
  end
end
