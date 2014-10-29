class LocationClonerJob
  extend HerokuResqueAutoscaler if Rails.env.production?
  @queue = :cloner

  def self.perform(source_location_id, target_location_id)
    Cloner::LocationCloner.new(source_location_id, target_location_id).clone
  end
end
