class WebsiteFinder::Base
  def initialize(object)
    @object = object
  end

  def layout_setting_for(object_id)
    ::Setting.where("value = ?", object_id.to_yaml).find do |setting|
      setting.name =~ /(?=(column|row))(?=.*widget_id).*/
    end
  end
end
