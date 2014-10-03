class AddWidgetTypeToGardenWidgets < ActiveRecord::Migration
  def change
    add_column :garden_widgets, :widget_type, :string
  end
end
