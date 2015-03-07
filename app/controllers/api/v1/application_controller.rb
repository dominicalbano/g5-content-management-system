class Api::V1::ApplicationController < ActionController::Base
  prepend_before_filter :authenticate_api_user!, unless: ENV['G5_AUTH_OFFLINE']
end

