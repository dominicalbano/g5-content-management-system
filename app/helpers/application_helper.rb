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

  def g5_user?
    return true if Rails.env.development?
    emails_regex = /@getg5.|@g5platform.|@g5searchmarketing./
    current_user.email =~ emails_regex ? true : false
  end

  def user_class
    g5_user? ? "g5-user" : "client-user"
  end
end
