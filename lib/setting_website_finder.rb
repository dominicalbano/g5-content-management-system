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

private

  def website_for(owner)
    return owner if owner.kind_of?(Website)
    owner.drop_target.web_template.website if owner.drop_target
  end

  def find_layout_setting_by_value(owner_id)
    Setting.where("name LIKE '%widget_id'").find do |setting|
      setting.value = owner_id
    end
  end
end


