class AddParentIdToWebTemplate < ActiveRecord::Migration
  def change
    add_column :web_templates, :parent_id, :integer
  end
end
