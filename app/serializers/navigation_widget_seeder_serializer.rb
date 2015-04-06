class NavigationWidgetSeederSerializer < ExtendedWidgetSeederSerializer
  protected

  def extended_settings_list
    ['display_navigation', 'display_as_calls_to_action', 'display_corporate_navigation']
  end
end
