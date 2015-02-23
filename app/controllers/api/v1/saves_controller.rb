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
    result = saves_manager.save
    redirect_to root_path, notice: "#{result}"
  end

  private

  def saves_manager
    user_email = current_user.email
    SavesManager.new(email)
  end
end

