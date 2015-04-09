class ButtonWidgetSeederSerializer < ExtendedWidgetSeederSerializer
  protected

  def extended_settings_list
    ['button_label','button_url','button_image_url','button_layout']
  end
end
