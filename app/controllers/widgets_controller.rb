class WidgetsController < ApplicationController
  respond_to :html, :json, :js
  def edit
    @widget = Widget.find(params[:id])
    @form_html = @widget.edit_form_html_rendered
    html = render_to_string(format: :html, layout: false)
    respond_with do |format|
      format.json { render json: {html: html} }
    end
  end

  def update
    @widget = Widget.find(params[:id])
    if @widget.update_attributes(params[:widget])
      respond_with(@widget) do |format|
        format.json { render json: @widget, status: 204}
        format.html { redirect_to website_web_page_template_path(@widget.web_template) }
      end
    else
      respond_with do |format|
        format.json { render json: {errors: @widget.errors}, status: :unprocessable_entity}
        format.html { render :edit }
      end
    end
  end
end
