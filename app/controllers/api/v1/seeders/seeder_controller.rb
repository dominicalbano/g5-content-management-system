class Api::V1::Seeders::SeederController < Api::V1::ApplicationController
  def index
    response = serializer.new(nil).get_yaml_files unless serializer.blank?
    render json: response, status: (response.blank? ? 500 : 200)
  end
  
  def show
    response = serializer.new(nil).get_yaml_files.inject([]) do |arr, file|
      prefix = /^#{params[:id].underscore}/
      arr << file unless prefix.match(file).blank?
      arr
    end unless serializer.blank?
    render json: response, status: (response.blank? ? 500 : 200)
  end

  def serialize
    return if serializer.blank?
    response = serializer.new(@object).to_yaml_file if serializer_object
    render json: { yml: response }, status: (response.blank? ? 500 : 200)
  end

  def seed
    return if seeder.blank?
    response = seeder.new(@object, params[:yml]).seed if (seeder_object && !params[:yml].blank?)
    render json: { object: response }, status: (response.blank? ? 500 : 200)
  end

  def serializer
    nil # abstract
  end

  def seeder
    nil # abstract
  end

  def serializer_object
    @object = nil # abstract
  end

  def seeder_object
    @object = nil # abstract
  end
end