module WebTemplatesHelper
  def preview(web_layout, web_template)
    base_html(web_layout, web_template).to_html
  end

  def base_html(web_layout, web_template)
    # get the web layout html
    html = Nokogiri.parse(web_layout.html)
    # put each widgets in its drop target in the web layout html
    web_template.all_widgets.group_by(&:html_id).each do |html_id, widgets|
      # find html element by id
      html_section = html.at_css("##{html_id}")
      if html_section
        inner_html = widgets.map(&:render_show_html).join
        html_section.inner_html = inner_html
      end
    end

    html
  end

  def head_widgets(web_template)
    web_template.head_widgets.map(&:render_show_html).join
  end

  def meta_description_widgets(web_template)
    web_template.meta_description_widgets.map(&:render_show_html).join
  end

  def preview_configs(params, web_template, corp_check)
    { urn: params['urn'],
      slug: web_template.website.client.vertical_slug,
      corporate: corp_check,
      slug_corporate: web_template.website.web_home_template.preview_url }.to_json.html_safe
  end

end
