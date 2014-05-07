class WebCorporateHomeTemplate < WebTemplate
  def all_widgets
    widgets.not_meta_description + website.try(:website_template).try(:widgets).to_a
  end

  def head_widgets
    website.try(:website_template).try(:head_widgets).to_a
  end

  def compile_path
    File.join(website_compile_path.to_s, "index.html") if website_compile_path
  end

  def preview_url
    "/#{vertical}/#{state}/#{city}/"
  end

  def htaccess_substitution
    relative_path
  end

  def relative_path
    "/"
  end
end
