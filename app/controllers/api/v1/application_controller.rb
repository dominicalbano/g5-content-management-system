class Api::V1::ApplicationController < ActionController::Base
  prepend_before_filter :authenticate_api_user!
end

