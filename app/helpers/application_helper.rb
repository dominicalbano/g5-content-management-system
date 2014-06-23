module ApplicationHelper

  def image_tag_or_placeholder(src, options={})
    if src.blank?
      src = "http://placehold.it/#{options[:width] || 100 }x#{options[:height] || 100}"
    end
    image_tag(src, options)
  end

  def leads_service_js
    url = client.urn.gsub("-c-", "-cls-")
    domain = "herokuapp.com"
    "//#{url}.#{domain}/assets/form_enhancer.js"
  end
end
