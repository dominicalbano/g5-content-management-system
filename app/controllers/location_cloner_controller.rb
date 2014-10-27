class LocationClonerController < ApplicationController
  layout "internal"

  def index
    scope = Location.select([:name, :id])
    @locations = ActiveRecord::Base.connection.select_all(scope).rows
  end

  def clone_location
    params["target_location_ids"].each do |location_id|
      Resque.enqueue(LocationClonerJob, params["source_location"], location_id)
    end

    flash[:notice] = "Your location(s) are being cloned"
    render action: :index
  end
end
