class DeleteHoursWidget < ActiveRecord::Migration
  def change
    Widget.where(garden_widget_id: GardenWidget.find_by_name("Hours")).destroy_all
  end
end
