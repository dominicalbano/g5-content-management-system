class Api::V1::Seeders::WebsitesController < Api::V1::Seeders::SeederController
  ##TODO: remove this! need to work with Maeve to make my POST requests work
  skip_before_filter :authenticate_api_user!

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
    @object ||= params[:id]
  end
end
