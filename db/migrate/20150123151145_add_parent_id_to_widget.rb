class AddParentIdToWidget < ActiveRecord::Migration
  def change
    add_column :widgets, :parent_id, :integer
  end
end
