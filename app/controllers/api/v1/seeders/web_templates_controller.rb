class Api::V1::Seeders::WebTemplatesController < Api::V1::Seeders::SeederController
  ##TODO: remove this! need to work with Maeve to make my POST requests work
  skip_before_filter :authenticate_api_user!

  def serializer
    WebPageTemplateSeederSerializer
  end

  def seeder
    WebPageTemplateSeederJob
  end

  def serializer_object
    @object ||= web_template
  end

  def seeder_object
    @object ||= params[:id]
  end
end
