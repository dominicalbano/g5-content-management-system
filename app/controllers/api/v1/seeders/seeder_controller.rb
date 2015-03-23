class Api::V1::Seeders::SeederController < Api::V1::ApplicationController
  def index
    response = serializer.new(nil).get_yaml_files unless serializer.blank?
    json = response.to_json({root: false}) if response
    render json: json.gsub('.yml',''), status: (json.blank? ? 500 : 200)
  end
  
  def show
    response = serializer.new(nil).get_yaml_files.inject([]) do |arr, file|
      prefix = /^#{params[:id].underscore}/
      arr << file unless prefix.match(file).blank?
      arr
    end unless serializer.blank?
    json = response.to_json({root: false}) if response
    render json: json.gsub('.yml',''), status: (json.blank? ? 500 : 200)
  end

  def serialize
    return if serializer.blank?
    response = serializer.new(@object).to_yaml_file if serializer_object
    render json: { yml: response }, status: (response.blank? ? 500 : 200)
  end

  def seed
    return if seeder.blank?
    if seeder_object && !params[:yml].blank?
      Resque.enqueue(seeder, @object, params[:yml])
      render json: { message: "Seeder enqueued" }, status: 202
    else
      render json: { message: "Invalid seeder object" }, status: (response.blank? ? 500 : 200)
    end
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

  protected

  def location
    Location.find_by_urn(params[:id]) if params[:id]
  end

  def website
    location.website if location
  end

  def web_template
    website.web_templates.find_by_slug(@slug) if website && !slug.blank?
  end

  def slug
    @slug ||= params[:slug] if params[:slug]
  end
end