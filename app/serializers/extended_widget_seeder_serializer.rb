class ExtendedWidgetSeederSerializer < ActiveModel::Serializer
  attributes  :slug,
              :settings

  def settings
    settings_list.inject([]) do |arr, setting|
      s = object.settings.where_name(setting).first
      arr << { name: s.name, value: reverse_liquid(s.value) } if s && !s.value.blank?
      arr
    end
  end

  protected

  def settings_list
    [] ## abstract
  end

  def use_reverse_liquid?
    false ## abstract
  end

  def reverse_liquid(value)
    object.liquid_parameters.each do |key, val|
      value.gsub!(val, "{{#{key}}}") unless val.blank?
    end if object.liquid && use_reverse_liquid?
    value
  end
end
