class PhotoWidgetSeederSerializer < ExtendedWidgetSeederSerializer
  def default_photo_source_url
    placeholdit_url(get_container_size)
  end

  def default_photo_alignment
    'photo-block'
  end

  protected

  def extended_settings_list
    ['photo_source_url','photo_link_url','photo_alt_tag','photo_caption','photo_class']
  end

  def default_settings_list
    ['photo_source_url','photo_alignment']
  end

  def placeholdit_url(size)
    height = (size / 1.618).round
    "http://placehold.it/#{size}x#{height}"
  end

  def get_container_size
    cs = object.parent_content_stripe
    case cs.try(:layout)
      when "single"
        1140
      when "halves"
        540
      when "uneven-thirds-1"
        get_uneven_thirds_size(cs)
      when "uneven-thirds-2"
        get_uneven_thirds_size(cs)
      when "thirds"
        350
      when "fourths"
        255
      else
        1140
    end
  end

  def get_uneven_thirds_size(cs)
    pw = object.parent_widget
    if pw.kind_of_widget?('column')
      is_first = (cs.get_child_widget(1) == pw)
    else
      is_first = (cs.get_child_widget(1) == object)
    end

    if is_first && cs.layout == "uneven-thirds-1" || !is_first && cs.layout == "uneven-thirds-2"
      350
    else
      760
    end
  end
end
