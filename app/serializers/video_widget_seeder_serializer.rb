class VideoWidgetSeederSerializer < ExtendedWidgetSeederSerializer
  protected

  def extended_settings_list
    ['video_id', 'video_title', 'source']
  end
end
