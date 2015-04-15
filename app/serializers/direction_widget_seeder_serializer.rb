class DirectionWidgetSeederSerializer < ExtendedWidgetSeederSerializer
  protected

  def extended_settings_list
    [
      'location_street_address',
      'location_city',
      'location_postal_code'
    ]
  end
end
