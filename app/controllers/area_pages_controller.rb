class AreaPagesController < ApplicationController
  def show
    return unless Location.corporate

    render "area_pages/show", layout: "web_template", locals: {
      locations: LocationCollector.new(params).collect,
      web_template: Location.corporate.website.website_template,
      area: area,
      params: params,
      is_preview: true
    }

  end

private

  def area
    areas = [params[:neighborhood], params[:city], params[:state]]
    areas.reject(&:blank?).map(&:humanize).map(&:titleize).join(", ")
  end
end
