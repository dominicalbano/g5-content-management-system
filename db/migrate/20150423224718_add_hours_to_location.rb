class AddHoursToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :office_hours, :string, :default => ""
    add_column :locations, :access_hours, :string, :default => ""
  end
end
