module ApplicationHelper

  def image_tag_or_placeholder(src, options={})
    if src.blank?
      src = "http://placehold.it/#{options[:width] || 100 }x#{options[:height] || 100}"
    end
    image_tag(src, options)
  end

  def leads_service_js
    ClientServices.new.cls_url(secure: true) + "assets/form_enhancer.js"
  end
end
