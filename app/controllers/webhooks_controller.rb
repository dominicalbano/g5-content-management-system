class WebhooksController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_before_filter :verify_authenticity_token

  def update
    Resque.enqueue(ClientUpdaterJob)
    render json: {}, status: :ok
  end
end
