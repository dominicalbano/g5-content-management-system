class AddLiquidToGardenWidgets < ActiveRecord::Migration
  def change
    add_column :garden_widgets, :liquid, :boolean, :default => false
  end
end
