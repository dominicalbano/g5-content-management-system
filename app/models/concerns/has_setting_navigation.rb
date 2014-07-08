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
      partial_hash = HashWithToLiquid.new
      partial_hash["display"] = web_template.display
      partial_hash["name"] = web_template.name
      partial_hash["url"] = web_template.url
      partial_hash["top_level"] = web_template.child_templates.present?
      partial_hash["child_templates"] = web_template.child_templates
      hash["#{web_template.id}"] = partial_hash
    end
    hash
  end
end
