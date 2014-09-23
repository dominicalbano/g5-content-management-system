class Api::V1::SavesController < Api::V1::ApplicationController
  def index
    render json: saves_manager.fetch_all
  end

  def rollback
    saves_manager.rollback(params[:save_id])
    redirect_to root_path, notice: "Rolling Back Deploy. This may take a few minutes."
  end

  private

  def saves_manager
    SavesManager.new
  end
end

