class WebTemplatesController < ApplicationController
  before_filter :find_website
  before_filter :find_web_template, only: [:show, :edit, :update, :destroy, :preview]

  def index
    @web_templates = web_template_klass.all
    render "web_templates/index"
  end

  def show
    render "web_templates/show"
  end

  def new
    @web_template = web_template_klass.new
    render "web_templates/new"
  end

  def create
    @web_template = @website.web_templates.new(web_template_params)
    if @web_template.save
      redirect_to website_url(@website), notice: "Successfully created."
    else
      render "/web_templates/new"
    end
  end

  def edit
    render "web_templates/edit", :layout => 'builder'
  end

  def update
    if @web_template.update_attributes(web_template_params)
      respond_to do |format|
        format.json { render json: @web_template.reload.widgets.last }
        format.html { redirect_to website_url(@website), notice: "Successfully updated." }
      end
    else
      render "web_templates/edit", layout: "builder"
    end
  end

  def preview
    render "web_templates/preview", layout: "compiled_pages",
      locals: { website: @website, web_template: @web_template, mode: "preview" }
  end

  private

  def web_template_klass
    WebTemplate
  end

  def web_template_params
    params[:web_template]
  end

  def find_website
    @website = Website.find_by_urn(params[:website_id])
  end

  def find_web_template
    @web_template = WebTemplate.find(params[:id])
  end
end
