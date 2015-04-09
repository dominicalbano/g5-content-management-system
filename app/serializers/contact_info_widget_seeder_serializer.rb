class ContactInfoWidgetSeederSerializer < ExtendedWidgetSeederSerializer
  protected

  def extended_settings_list
    ['maps_url','location_email']
  end
end
