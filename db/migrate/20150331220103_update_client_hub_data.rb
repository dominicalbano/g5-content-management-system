class UpdateClientHubData < ActiveRecord::Migration
  def change
    ClientReader.new(ENV["G5_CLIENT_UID"]).perform
    GardenWidgetUpdater.new.update_all(true)
  end
end
