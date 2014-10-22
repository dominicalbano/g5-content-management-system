class WebTemplateCloner
  def initialize(template, target_website)
    @template = template
    @target_website = target_website
  end

  def clone
    new_template = @template.dup
    new_template.update({website_id: @target_website.id})

    clone_layout(@template, new_template)
    clone_theme(@template, new_template)
    clone_drop_targets(@template.drop_targets, new_template)
  end

  private

  def clone_layout(template, new_template)
    return unless template.slug == 'web-template'
    template.web_layout.dup.update(web_template_id: new_template.id)
  end

  def clone_theme(template, new_template)
    return unless template.slug == 'web-template'
    template.web_theme.dup.update(web_template_id: new_template.id)
  end

  def clone_drop_targets(drop_targets, new_template)
    drop_targets.each do |drop_target|
      new_drop_target = drop_target.dup
      new_drop_target.update(web_template_id: new_template.id)

      clone_widgets(drop_target.widgets, new_drop_target)
    end
  end

  def clone_widgets(widgets, drop_target)
    widgets.each do |widget|
      new_widget = widget.dup
      new_widget.update(drop_target_id: drop_target.id)

      clone_widget_settings(widget, new_widget)
    end
  end

  def clone_widget_settings(source_widget, target_widget)
    source_widget.settings.each do |setting|
      next if /widget_id$/ =~ setting.name # Never set the setting 'widget_id'
      target_widget.settings.where({name: setting.name}).first.update({value: setting.value})
      next unless /widget_name$/ =~ setting.name # then we just created a new widget

      clone_child_widgets(source_widget, target_widget, setting)
    end
  end

  def clone_child_widgets(source_widget, target_widget, setting)
    new_widget = setting_value_for(target_widget, setting)
    original_widget = setting_value_for(source_widget, setting)

    if setting.value == 'Row' || setting.value == 'Column'
      clone_widget_settings(new_widget, original_widget)
    else
      original_widget.settings.each do |original_widget_setting|
        new_widget.settings.where({name: original_widget_setting.name}).first.update({value: original_widget_setting.value})
      end
    end
  rescue
  end

  def setting_value_for(widget, setting)
    Widget.find(widget.settings.where({name: setting.name.gsub('_name', '_id')}).first.value)
  end
end
