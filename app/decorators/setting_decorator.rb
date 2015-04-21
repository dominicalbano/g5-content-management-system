class SettingDecorator < Draper::Decorator

  delegate_all

  liquid_methods  :id_hidden_field,
                  :field_name,
                  :field_id,
                  :value_field_name,
                  :value_field_id,
                  :value,
                  :value_or_default,
                  :best_value

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
end
