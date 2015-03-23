class CorporateNavigationSetting
  def setting
    return unless corporate_location.present?
    corporate_navigation_setting
  end

  def value
    return unless corporate_location.present?
    corporate_navigation_setting.value
  end

  private

  def corporate_location
    @corporate_location ||= Location.where(corporate: true).first
  end

  def corporate_website
    corporate_location.website
  end

  def corporate_navigation_setting
    @corporate_navigation_setting ||=
      corporate_website.settings.where(name: "navigation").first
  end
end
