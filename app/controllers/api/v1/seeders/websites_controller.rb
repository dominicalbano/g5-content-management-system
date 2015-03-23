class Api::V1::Seeders::WebsitesController < Api::V1::Seeders::SeederController
  ##TODO: remove this! need to work with Maeve to make my POST requests work
  skip_before_filter :authenticate_api_user!

  def serializer
    WebsiteSeederSerializer
  end

  def seeder
    Seeder::WebsiteSeeder
  end

  def serializer_object
    @object ||= location
  end

  def seeder_object
    @object ||= location
  end

  private

  def location
    Location.find_by_urn(params[:id]) if params[:id]
  end
end
