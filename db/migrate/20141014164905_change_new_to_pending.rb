class ChangeNewToPending < ActiveRecord::Migration
  def change
    change_column :locations, :status, :string, default: "Pending"

    Location.all.each do |location|
      location.update(status: "Pending") if location.status == "New"
    end
  end
end
