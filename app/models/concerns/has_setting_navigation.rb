require_dependency "hash_with_to_liquid"

module HasSettingNavigation
  extend ActiveSupport::Concern

  # not sure this was necessary to make it plural, there should only
  # be one website level navigation setting
  def navigation_settings
    @navigation_settings = settings.where(name: "navigation")
    unless @navigation_settings.present?
      settings.create(
        name: "navigation",
        categories: ["collection"]
      )
      @navigation_settings = settings.where(name: "navigation")
    end
    @navigation_settings
  end

  def update_navigation_settings
    navigation_settings.each do |navigation_setting|
      navigation_setting.update_attribute(:value,
                                          navigateable_web_templates_to_hashes)
    end
  end

  def navigateable_web_templates
    web_templates.navigateable.rank(:display_order).decorate
  end

  def navigateable_web_templates_to_hashes
    hash = {}
    navigateable_web_templates.each do |web_template|
      hash["#{web_template.id}"] = to_liquid(web_template)
    end
    hash
  end

  def to_liquid(web_template)
    partial_hash = HashWithToLiquid.new
    partial_hash["display"] = web_template.display
    partial_hash["name"] = web_template.name
    partial_hash["url"] = web_template.url
    partial_hash["top_level"] = web_template.top_level
    partial_hash["child_template?"] = web_template.child_template?

    child_templates = web_template.child_templates.map do |child_template|
      to_liquid(child_template)
    end

    partial_hash["child_templates"] = child_templates
    partial_hash
  end
end
