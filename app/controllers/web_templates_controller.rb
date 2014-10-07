class WebTemplatesController < ApplicationController
  def show
    @location = Location.where(
      "lower(city_slug) = ?", params[:city_slug].to_s.downcase).first

    @website = @location.website if @location

    if @website
      if params[:web_template_slug]
        @web_template = @website.web_page_templates.where(
          "lower(slug) = ?", params[:web_template_slug].to_s.downcase).first
      else
        @web_template = @website.web_home_template
      end
    end

    render "web_templates/show", layout: "web_template",
      locals: {
        location: @location,
        website: @website,
        web_template: @web_template,
        mode: "preview"
      }
  end
end
