class GardenWidgetUpdaterJob
  extend HerokuResqueAutoscaler if Rails.env.production?
  @queue = :garden_widget_updater

  def self.perform(force_all=false)
    GardenWidgetUpdater.new.update_all(force_all)
  end
end
