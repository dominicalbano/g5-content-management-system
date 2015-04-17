class ContactInfoWidgetSeederSerializer < ExtendedWidgetSeederSerializer
  protected

  def extended_settings_list
    [
      'location_name',
      'location_street_address',
      'location_city',
      'location_postal_code',
      'location_country',
      'location_tel',
      'location_email',
      'maps_url',
      'location_email'
    ]
  end
end
