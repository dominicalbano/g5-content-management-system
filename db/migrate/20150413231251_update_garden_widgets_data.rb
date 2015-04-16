class UpdateGardenWidgetsData < ActiveRecord::Migration
  def change
    Resque.enqueue(GardenWidgetUpdaterJob, true)
  end
end
