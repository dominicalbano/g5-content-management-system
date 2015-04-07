class GalleryWidgetSeederSerializer < ExtendedWidgetSeederSerializer
  MAX_IMAGES = 20

  protected

  def extended_settings_list
    arr = ['gallery_title', 'gallery_thumbnails','gallery_mini','gallery_carousel']
    (1..MAX_IMAGES).each do |idx|
      arr += ["gallery_photo#{idx}_url", "gallery_photo#{idx}_thumb_url","gallery_photo#{idx}_alt_tag","gallery_photo#{idx}_title","gallery_photo#{idx}_caption"]
    end
    arr
  end
end
