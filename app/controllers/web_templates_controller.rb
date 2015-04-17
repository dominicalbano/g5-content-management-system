class WebTemplatesController < ApplicationController
  skip_before_filter :authenticate_user!

  def show
    @location = Location.where("urn = ?", params[:urn]).first
    @website = @location.website if @location

    if @website
      if params[:web_template_slug]
        @web_template = @website.web_page_templates.where(
          "lower(slug) = ?", params[:web_template_slug].to_s.downcase).first || @website.web_home_template
      else
        @web_template = @website.web_home_template
      end
    end

    render "web_templates/show", layout: "web_template",
      locals: {
        location: @location,
        website: @website,
        web_template: @web_template,
        mode: "preview",
        is_preview: true
      }
  end
end
