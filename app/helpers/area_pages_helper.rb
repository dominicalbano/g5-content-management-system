module AreaPagesHelper
  def area_preview(web_template, locations, area)
    Rails.logger.debug("inside area_preview helper method with locations: #{locations.map(&:inspect)}")
    html = base_html(web_template.web_template_layout_html, web_template)
    html_section = html.at_css("#drop-target-main")
    html_section.inner_html = AreaPageRenderer.new(locations, area).render

    html.to_html
  end

  def canonical_link_element(params, web_template)
    url = File.join(web_template.send(:domain_for_type), query(params))
    "<link rel='canonical' href='#{url}' />"
  end

private

  def query(params)
    [params[:state], params[:city], params[:neighborhood]].reject(&:blank?).join("/")
  end
end
