class WebsiteFinder::Base
  def initialize(object)
    @object = object
  end

  def layout_setting_for(object)
    ::Setting.where("value = ?", object.id.to_yaml).find do |setting|
      setting.name =~ /(?=(column|row))(?=.*widget_id).*/
    end
  end
end
