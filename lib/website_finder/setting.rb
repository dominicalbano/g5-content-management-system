class WebsiteFinder::Setting < WebsiteFinder::Base
  def initialize(setting)
    @setting = setting
    @owner = @setting.owner
    @website = nil
  end

  def find
    loop do
      @website = website_for(@owner)
      return @website if @website.present?
      setting = layout_setting_for(@owner)
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
end
