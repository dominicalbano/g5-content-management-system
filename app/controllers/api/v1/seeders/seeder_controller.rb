class Api::V1::Seeders::SeederController < Api::V1::ApplicationController
  def index
    render json: serializer.new(nil).get_yaml_files unless serializer.blank?
  end
  def show
    return if serializer.blank?
    results = serializer.new(nil).get_yaml_files.inject([]) do |arr, file|
      prefix = /^#{params[:id].underscore}/
      arr << file unless prefix.match(file).blank?
      arr
    end
    render json: results
  end

  def serializer
    nil # abstract
  end
end