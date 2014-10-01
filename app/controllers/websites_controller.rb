class WebsitesController < ApplicationController
  def deploy
    binding.pry
    user_email = current_user.email
    @website = Website.find(params[:id])
    @website.async_deploy(user_email)
    redirect_to root_path, notice: "Deploying website #{@website.name}. This may take few minutes."
  end
end
