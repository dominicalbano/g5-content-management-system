class Api::V1::ClientsController < Api::V1::ApplicationController
  def show
    render json: Client.first, serializer: ClientSerializer
  end

  def deploy_websites
    user_email = current_user.email
    Client.first.async_deploy(user_email)
    render json: {message: "Deploying websites. This may take few minutes."}
  end
end
