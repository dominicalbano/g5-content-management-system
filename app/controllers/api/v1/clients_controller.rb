class Api::V1::ClientsController < Api::V1::ApplicationController
  def show
    render json: Client.first, serializer: ClientSerializer
  end

  def deploy_websites
    user_email = current_user.email
    Location.all.each {|location| location.website.async_deploy(user_email) }
    render json: {message: "Deploying all websites. This may take few minutes."}
  end
end
