class Api::V1::Seeders::ContentStripesController < Api::V1::Seeders::SeederController
  ##TODO: remove this! need to work with Maeve to make my POST requests work
  skip_before_filter :authenticate_api_user!

  def serializer
    ContentStripeWidgetSeederSerializer
  end

  def seeder
    ContentStripeWidgetSeederJob
  end

  def serializer_object
    @object ||= widget
  end

  def seeder_object
    @object ||= web_template
  end

  private

  def widget
    w = Widget.find(params[:id]) if params[:id]
    return w if w.try(:is_content_stripe?)
  end
end
