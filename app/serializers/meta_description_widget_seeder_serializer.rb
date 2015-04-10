class MetaDescriptionWidgetSeederSerializer < ExtendedWidgetSeederSerializer
  protected

  def extended_settings_list
    ['meta_description']
  end

  def use_reverse_liquid?
    #true
    false
  end
end
