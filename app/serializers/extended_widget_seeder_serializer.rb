class ExtendedWidgetSeederSerializer < ActiveModel::Serializer
  attributes  :slug,
              :settings

  def settings
    settings_list.inject([]) do |arr, setting|
      s = object.settings.where_name(setting).first
      arr << { name: s.name, value: s.value } if s && !s.value.blank?
      arr
    end
  end

  protected

  def settings_list
    []
  end
end
