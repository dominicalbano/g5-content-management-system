class AddWidgetIdToGardenWidgets < ActiveRecord::Migration
  def change
    add_column :garden_widgets, :widget_id, :integer
  end
end
