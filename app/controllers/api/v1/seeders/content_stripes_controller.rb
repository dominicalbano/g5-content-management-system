class Api::V1::Seeders::ContentStripesController < Api::V1::Seeders::SeederController
  ##TODO: remove this! need to work with Maeve to make my POST requests work
  skip_before_filter :authenticate_api_user!

  def serializer
    ContentStripeWidgetSeederSerializer
  end

  def seeder
    ContentStripeWidgetSeeder
  end

  def serializer_object
    @object ||= widget
  end

  def seeder_object
    ##TODO
  end

  private

  def widget
    Widget.find_by_urn(params[:id]) if params[:id]
  end
end
