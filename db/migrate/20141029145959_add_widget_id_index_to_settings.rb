class AddWidgetIdIndexToSettings < ActiveRecord::Migration
  def change
    add_index :settings, :owner_id
  end
end
