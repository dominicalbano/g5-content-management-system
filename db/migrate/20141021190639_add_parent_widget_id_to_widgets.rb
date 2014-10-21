class AddParentWidgetIdToWidgets < ActiveRecord::Migration
  def change
    add_column :widgets, :parent_widget_id, :integer
  end
end
