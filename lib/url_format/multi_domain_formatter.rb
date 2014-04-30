class URLFormat::MultiDomainFormatter < URLFormat::Formatter
  def format
    return URLFormat::Formatter::ROOT if web_home_template?

    "#{seo_optimized_path}/#{@web_template.slug}"
  end

  private

  def web_home_template?
    @web_template.type == "WebHomeTemplate"
  end
end
