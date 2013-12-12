module AfterUpdateSetSettingNavigation
  extend ActiveSupport::Concern

  included do
    after_create :update_navigation_settings
    after_update :update_home_page_template_display_order, if: :display_order_changed?
    after_update :update_navigation_settings, if: :should_update_navigation_settings?
  end

  private

  def should_update_navigation_settings?
    name_changed? || display_order_changed? || enabled_changed?
  end

  def update_navigation_settings
    website.try(:update_navigation_settings)
  end

  def update_home_page_template_display_order
    if !web_home_template? && website && website.web_home_template
      website.web_home_template.update_attribute(:display_order, -9999999)
    end
  end
end
