class GardenWidgetUpdaterJob
  extend HerokuResqueAutoscaler if Rails.env.production?
  @queue = :garden_widget_updater

  def self.perform(force_all=false, only_these_widgets=[])
    GardenWidgetUpdater.new.update_all(force_all, only_these_widgets)
  end
end
