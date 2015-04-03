class AddWidgetTooltipToGardenWidgets < ActiveRecord::Migration
  def change
    add_column :garden_widgets, :widget_popover, :text, default: ''
  end
end
