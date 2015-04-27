class WebHomeTemplate < WebTemplate
  def all_widgets
    widgets.not_meta_description + website.try(:website_template).try(:widgets).to_a
  end

  def head_widgets
    website.try(:website_template).try(:head_widgets).to_a
  end

  def compile_path
    File.join(base_path.to_s, relative_path, "index.html") if base_path
  end

  def preview_url
    "#{owner.urn}/#{client.vertical_slug}/#{owner.state_slug}/#{owner.city_slug}"
  end

  def htaccess_substitution
    if single_domain?
      ["/", website.single_domain_location_path, "/"].join
    else
      relative_path
    end
  end

  def relative_path
    "/"
  end
end

