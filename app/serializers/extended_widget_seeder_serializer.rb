class ExtendedWidgetSeederSerializer < ActiveModel::Serializer
  attributes  :slug,
              :settings

  def settings
    settings_list.inject([]) do |arr, setting|
      if extended_settings_list.include?(setting)
        s = object.get_setting(setting)
        val = reverse_liquid(s.value) if s && !s.value.blank?
      end
      
      val ||= self.try("default_#{setting}")
      val ||= object.get_setting(setting).default_value if default_settings_list.include?(setting)
      arr << { name: setting, value: val } unless val.blank?
      arr
    end
  end

  protected

  def settings_list
    default_settings_list | extended_settings_list
  end

  def default_settings_list
    [] ## abstract
  end

  def extended_settings_list
    [] ## abstract
  end

  def use_reverse_liquid?
    false ## abstract
  end

  def reverse_liquid(value)
    object.liquid_parameters.each do |key, val|
      value.gsub!(val, "{{#{key}}}") if (val.is_a?(String) && !val.blank?)
    end if object.liquid && use_reverse_liquid?
    value
  end
end
