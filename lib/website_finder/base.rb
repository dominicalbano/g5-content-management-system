class WebsiteFinder::Base
  def initialize(object)
    @object = object
  end

  private

  def layout_setting
    Setting.where("value = ?", @object.id.to_yaml).find do |setting|
      setting.name =~ /(?=(column|row))(?=.*widget_id).*/
    end
  end
end
