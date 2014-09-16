class Api::V1::ReleasesController < Api::V1::ApplicationController
  def index
    render json: release_manager.fetch_all
  end

  def rollback
    release_manager.rollback(params[:release_id])
    redirect_to root_path, notice: "Rolling Back Deploy. This may take a few minutes."
  end

  private

  def release_manager
    ReleasesManager.new(params["website_id"])
  end
end
