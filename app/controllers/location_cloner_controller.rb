class LocationClonerController < ApplicationController
  layout "internal"

  def index
    scope = Location.select([:name, :id])
    @locations = ActiveRecord::Base.connection.select_all(scope).rows
  end

  def clone_location
    Resque.enqueue(LocationClonerJob, params["source_location"], params["target_location"])
    flash[:notice] = "Location is being cloned"
    redirect_to :back
  end
end
