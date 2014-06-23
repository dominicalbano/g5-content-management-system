class NavigationSettingWebsiteFinder
  def initialize(setting)
    @setting = setting
    @widget = @setting.owner
    @website = nil
  end

  def find
    loop do
      @website = website_for(@widget)
      return @website if @website.present?

      setting = find_setting(@widget.id)
      return unless setting

      @widget = setting.owner
      @website = website_for(@widget)
      return @website if @website.present?
    end
  end

private

  def website_for(owner)
    return owner if owner.kind_of?(Website)
    owner.drop_target.web_template.website if owner.drop_target
  end

  def find_setting(widget_id)
    Setting.find do |setting|
      setting.name =~ /(?=(column|row))(?=.*widget_id).*/ && setting.value == widget_id
    end
  end
end
