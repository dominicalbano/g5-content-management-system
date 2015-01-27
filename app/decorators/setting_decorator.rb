class SettingDecorator < Draper::Decorator

  delegate_all

  liquid_methods  :id_hidden_field,
                  :field_name,
                  :field_id,
                  :value_field_name,
                  :value_field_id,
                  :value,
                  :best_value,
                  :location_settings

  def owner_name
    owner.name if owner && owner.respond_to?(:name)
  end

  def id_hidden_field
    h.hidden_field_tag("#{field_name}[id]", id)
  end

  def field_name
    "#{owner_type.underscore}[settings_attributes][#{id}]"
  end

  def field_id
    field_name.underscore
  end

  def value_field_name
    "#{field_name}[value]"
  end

  def value_field_id
    value_field_name.parameterize.gsub(/-/, "_")
  end

  def location_settings
    # reach up through parent widgets to get web_template and location info

    # going this route requires we set up a placeholder setting in index.html of the widget, and
    # then call .location_settings on that placeholder within the liquid.

    # also need to fine tune the migration that assigns the new parent_id attribute.

    parent = Widget.find_by_id owner.parent_id
    if parent
      { parent_id: owner.parent_id,
        location_urn: parent.web_template.owner.urn,
        primary_color: parent.web_template.website_colors[:primary_color],
        secondary_color: parent.web_template.website_colors[:secondary_color],
        tertiary_color: parent.web_template.website_colors[:tertiary_color]
      }.to_json
    else
      "{}"
    end
  end
end
