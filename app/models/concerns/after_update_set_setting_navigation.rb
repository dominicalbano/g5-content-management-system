module AfterUpdateSetSettingNavigation
  extend ActiveSupport::Concern

  included do
    after_create :update_navigation_settings
    after_update :update_home_page_template_display_order, if: :display_order_changed?
    after_update :update_navigation_settings, if: :should_update_navigation_settings?
  end

  private

  def should_update_navigation_settings?
    if !should_skip_update_navigation_settings.nil?
      !should_skip_update_navigation_settings
    else  
      name_changed? || display_order_changed? || enabled_changed? || in_trash_changed? || parent_id_changed?
    end
  end

  def update_navigation_settings
    Resque.enqueue(UpdateNavigationSettingsJob, website.id) if website
  end

  def update_home_page_template_display_order
    if !web_home_template? && website && website.web_home_template
      website.web_home_template.update_attribute(:display_order, -9999999)
    end
  end
end
