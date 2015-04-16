class LogoWidgetSeederSerializer < ExtendedWidgetSeederSerializer
  protected

  def extended_settings_list
    ['business_name','display_logo','logo_url']
  end
end
