class Api::V1::Seeders::WebTemplatesController < Api::V1::Seeders::SeederController
  ##TODO: remove this! need to work with Maeve to make my POST requests work
  skip_before_filter :authenticate_api_user!

  def serializer
    WebPageTemplateSeederSerializer
  end

  def seeder
    Seeder::WebPageTemplateSeeder
  end

  def serializer_object
    @object ||= web_template
  end

  def seeder_object
    @object ||= website
  end

  private

  def website
    Location.find_by_urn(params[:id]).try(:website) if params[:id]
  end

  def web_template
    website.web_templates.find_by_slug(@slug) if website && !slug.blank?
  end

  def slug
    @slug ||= params[:web_template][:slug] if params[:web_template]
  end
end
