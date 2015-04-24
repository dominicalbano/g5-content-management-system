class MetaWidgetSeederSerializer < ExtendedWidgetSeederSerializer
  def default_use_crazy_egg
    true
  end

  protected

  def default_settings_list
    ['use_crazy_egg']
  end
end
