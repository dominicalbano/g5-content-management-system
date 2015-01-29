class Api::V1::WebsitesController < Api::V1::ApplicationController
  def index
    render json: Website.all
  end

  def show
    render json: Website.all.detect{|website| website.slug == params[:id]}
  end

  def deploy
    user_email = current_user.email
    @website = Website.find(params[:website_id])
    @website.async_deploy(user_email)
    render json: {message: "Deploying website #{@website.name}. This may take few minutes."}
  end
end

