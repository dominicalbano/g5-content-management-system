class GardenComponentUpdater
  MAX_ATTEMPTS = 5
  TIMEOUT = 15

  def update_all(force_all=false, only_these=[])
    components_data = send_with_retry(:components_microformats)
    updated_components = components_data.inject([]) do |arr, component|
      garden_component = get_garden_component(component)
      update(garden_component, component) if update_garden_component?(garden_component, component, force_all, only_these)
      arr << garden_component
      arr
    end unless components_data.blank?

    removed_components = garden_components_class.all - (updated_components || [])
    removed_components.each do |removed|
      removed.destroy unless removed.try(:in_use?)
    end
  end

  protected

  def value_to_s(object, value)
    object.send(value).try(:to_s) if object.respond_to?(value)
  end

  def value_array_to_s(object, value)
    object.send(value).try(:map, &:to_s) if object.respond_to?(value)
  end

  def value_to_html(object, value)
    val = value_to_s(object, value)
    CGI.unescapeHTML(val) unless val.blank?
  end

  def components_microformats
    garden_components_class.try(:components_microformats)
  end

  def get_garden_component(component)
    garden_components_class.find_or_initialize_by(garden_components_id => garden_components_id_value(component))
  end

  def update_garden_component?(garden_component, component=nil, force_all=false, only_these=[])
    true
  end

  def garden_components_class
    raise NotImplementedError
  end

  def garden_components_id
    raise NotImplementedError
  end

  def garden_components_id_value(component)
    value_to_s(component, garden_components_id)
  end

  def send_with_retry(method, *args)
    attempts = 0
    begin
      return self.send(method, *args)
    rescue Exception => ex
      Rails.logger.info "Error getting html: #{ex}"
      unless Rails.env.test?
        attempts += 1
        sleep TIMEOUT
        retry if attempts < MAX_ATTEMPTS
      end
      raise ex
    end
  end

  def get_html_with_retry(html_file)
    send_with_retry(:get_html, html_file.to_s) if html_file
  end

  def get_html(url)
    open(url).read if url
  end

end