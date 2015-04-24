class Api::V1::Seeders::SeederController < Api::V1::ApplicationController
  # GET Endpoints

  def index
    response = serializer.new(nil).get_yaml_files unless serializer.blank?
    json = response_to_json(response)
    render json: json || {}, status: (json.blank? ? 422 : 200)
  end

  def show
    pattern = params[:id].downcase.underscore
    prefix = /^#{pattern}/
    response = serializer.new(nil).get_yaml_files.inject([]) do |arr, file|
      arr << file unless prefix.match(file).blank?
      arr
    end unless serializer.blank?
    json = response_to_json(response)
    render json: json || {}, status: (json.blank? ? 422 : 200)
  end

  # POST Endpoints

  def serialize
    return if serializer.blank?
    response = serializer.new(@object).to_yaml_file if serializer_object
    render json: { yml: response }, status: (response.blank? ? 422 : 200)
  end

  def seed
    return if seeder.blank?
    if seeder_object && yml
      Resque.enqueue(seeder, seeder_params, @yml)
      render json: { message: "Seeder enqueued" }, status: 202
    else
      render json: { message: "ERROR: Invalid parameters" }, status: 422
    end
  end

  # Abstract Methods

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

  def seeder_params
    {} # abstract
  end

  protected

  # Object Methods

  def location
    Location.find_by_urn(params[:id]) unless params[:id].blank?
  end

  def website
    location.website if location
  end

  def web_template
    website.web_templates.find_by_slug(@slug) if website && slug
  end

  def slug
    @slug ||= params[:slug] unless params[:slug].blank?
  end

  def yml
    @yml ||= params[:yml] unless params[:yml].blank?
  end

  def response_to_json(response)
    json = response.to_json({root: false}) if response
    json.gsub!('.yml','') if json
    json
  end
end