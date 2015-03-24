class Api::V1::Seeders::WebTemplatesController < Api::V1::Seeders::SeederController
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
    @object ||= location
  end

  def seeder_params
    @object.urn if seeder_object
  end
end
