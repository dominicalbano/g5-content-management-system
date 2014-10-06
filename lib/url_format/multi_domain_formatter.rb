class URLFormat::MultiDomainFormatter < URLFormat::Formatter
  def format
    return URLFormat::Formatter::ROOT if web_home_template?

    if @web_template.website.corporate?
      "/#{@web_template.slug}"
    else
      "#{seo_optimized_path}/#{@web_template.slug}"
    end
  end
end
