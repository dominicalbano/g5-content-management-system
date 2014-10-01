class Api::V1::SavesController < Api::V1::ApplicationController
  def index
    render json: saves_manager.fetch_all
  end

  def restore
    #safe_id — dont ask
    saves_manager.restore(params[:safe_id])
    redirect_to root_path, notice: "Restoring Save. This may take a few minutes."
  end

  def create
    saves_manager.save
    redirect_to root_path, notice: "Saving. This may take a few minutes."
  end

  private

  def saves_manager
    SavesManager.new(current_user.email)
  end
end

