class Api::V1::ClientsController < Api::V1::ApplicationController
  def show
    render json: Client.first, serializer: ClientSerializer
  end

  def deploy_websites
    Client.first.async_deploy
    redirect_to root_path, notice: "Deploying websites. This may take few minutes."
  end

  def update
    Resque.enqueue(ClientUpdaterJob)
    redirect_to root_path, notice: "Updating Client and Locations. This may take a few minutes."
  end
end
