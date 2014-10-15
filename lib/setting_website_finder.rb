class SettingWebsiteFinder
  def initialize(setting)
    @setting = setting
    @owner = @setting.owner
    @website = nil
  end

  def find
    loop do
      @website = website_for(@owner)
      return @website if @website.present?
      setting = find_layout_setting_by_value(@owner.id)
      return unless setting

      @owner = setting.owner
      @website = website_for(@owner)
      return @website if @website.present?
    end
  end

  def find_layout_setting_by_value(owner_id)
    owner_settings(owner_id).find { |setting| setting.name =~ /(column|row)/ }
  end

private

  def widget_id_settings
    Setting.where("name LIKE '%widget_id'")
  end

  def owner_settings(owner_id)
    widget_id_settings.select { |setting| setting.value == owner_id }
  end

  def website_for(owner)
    return owner if owner.kind_of?(Website)
    owner.drop_target.web_template.website if owner.drop_target
  end
end
