class AddWidgetModifiedToGardenWidgets < ActiveRecord::Migration
  def change
    add_column :garden_widgets, :widget_modified, :datetime, default: Time.zone.parse("1 Jan 2012") # a time before widgets were created
  end
end
