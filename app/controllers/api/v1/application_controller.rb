class Api::V1::ApplicationController < ActionController::Base
  prepend_before_filter :authenticate_api_user!, unless: proc{ Rails.env.development? }
  before_filter :set_headers, if: proc{ Rails.env.development? }

  def set_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Expose-Headers'] = 'ETag'
    headers['Access-Control-Allow-Methods'] = 'GET, POST, PATCH, PUT, DELETE, OPTIONS, HEAD'
    headers['Access-Control-Allow-Headers'] = '*,x-requested-with,Content-Type,If-Modified-Since,If-None-Match'
    headers['Access-Control-Max-Age'] = '86400'
  end
end

