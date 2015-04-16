class CallsToActionWidgetSeederSerializer < ExtendedWidgetSeederSerializer
  protected

  def extended_settings_list
    arr = []
    arr += ['cta_text_1','page_slug_1'] unless object.get_setting_value('cta_text_1').blank?
    arr += ['cta_text_2','page_slug_2'] unless object.get_setting_value('cta_text_2').blank?
    arr += ['cta_text_3','page_slug_3'] unless object.get_setting_value('cta_text_3').blank?
    arr += ['cta_text_4','page_slug_4'] unless object.get_setting_value('cta_text_4').blank?
    arr
  end
end
