class NavigationWidgetSeederSerializer < ExtendedWidgetSeederSerializer
  def default_display_navigation
    'false'
  end

  protected

  def extended_settings_list
    ['display_as_calls_to_action', 'display_corporate_navigation']
  end

  def default_settings_list
    ['display_navigation']
  end
end
