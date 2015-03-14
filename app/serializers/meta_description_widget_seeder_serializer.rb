class MetaDescriptionWidgetSeederSerializer < ExtendedWidgetSeederSerializer
  protected

  def settings_list
    ['meta_description']
  end

  def use_reverse_liquid?
    true
  end
end
