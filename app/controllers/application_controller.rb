class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :client_name
  helper_method :client
  prepend_before_filter :authenticate_user!, unless: proc{ Rails.env.development? }

  helper G5Header::ApplicationHelper

  before_filter :set_headers, if: proc{ Rails.env.development? }
  
  def set_headers
    headers['X-Frame-Options'] = 'ALLOWALL'
  end

  def client
    @client ||= Client.first
  end

  def client_name
    @client_name ||= client.name if client
  end

  def is_api_request?
    !G5AuthenticatableApi::TokenValidator.new(params,headers).access_token.nil?
  end
end
