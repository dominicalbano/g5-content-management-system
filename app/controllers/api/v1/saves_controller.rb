class Api::V1::SavesController < Api::V1::ApplicationController
  def index
    render json: saves_manager.fetch_all
  end

  def restore
    #safe_id — dont ask
    saves_manager.restore(params[:safe_id])
    render json: {message: "Restoring Save. This may take a few minutes."}
  end

  def create
    result = saves_manager.save
    render json: {message: "#{result}"}
  end

  private

  def saves_manager
    SavesManager.new(current_user.email)
  end
end

