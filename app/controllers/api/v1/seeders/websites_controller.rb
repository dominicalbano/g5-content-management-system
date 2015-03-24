class Api::V1::Seeders::WebsitesController < Api::V1::Seeders::SeederController
  def serializer
    WebsiteSeederSerializer
  end

  def seeder
    WebsiteSeederJob
  end

  def serializer_object
    @object ||= location
  end

  def seeder_object
    @object ||= location
  end

  def seeder_params
    @object.urn if seeder_object
  end
end
