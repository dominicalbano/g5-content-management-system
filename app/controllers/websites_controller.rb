class WebsitesController < ApplicationController
  def deploy
    @website = Website.find(params[:id])
    @website.async_deploy
    redirect_to root_path, notice: "Deploying website #{@website.name}. This may take few minutes."
  end
end
