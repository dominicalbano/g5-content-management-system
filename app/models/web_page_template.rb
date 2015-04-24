class WebPageTemplate < WebTemplate
  def all_widgets
    widgets.not_meta_description + website.try(:website_template).try(:widgets).to_a
  end

  def head_widgets
    website.try(:website_template).try(:head_widgets).to_a
  end

  def htaccess_substitution
    ["/", relative_path, "/"].join
  end

  def compile_path
    File.join(base_path.to_s, "#{relative_path}.html") if web_page_template?
  end

  def relative_path
    return slug if website.corporate? || single_domain?

    File.join(client.vertical_slug, owner.state_slug, owner.city_slug, slug)
  end

  def preview_url
    url.prepend(owner.urn + "/")
  end
end

