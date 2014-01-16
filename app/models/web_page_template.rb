class WebPageTemplate < WebTemplate
  def all_widgets
    widgets + website.try(:website_template).try(:widgets).to_a
  end

  def head_widgets
    website.try(:website_template).try(:head_widgets).to_a
  end

  def htaccess_substitution
    ["/", path, "/"].join
  end

  def compile_path
    File.join(website_compile_path.to_s, path, "index.html") if web_page_template?
  end

  def path
    File.join(client.vertical_slug, location.state_slug, location.city_slug, slug)
  end
end
