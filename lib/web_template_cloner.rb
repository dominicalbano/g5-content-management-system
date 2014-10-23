class WebTemplateCloner
  def initialize(template, target_website)
    @template = template
    @target_website = target_website
  end

  def clone
    new_template = @template.dup
    new_template.update({website_id: @target_website.id})

    clone_layout(new_template) if website_template?
    clone_theme(new_template) if website_template?
    clone_drop_targets(@template.drop_targets, new_template)
  end

  private

  def website_template?
    @template.type == "WebsiteTemplate"
  end

  def clone_layout(new_template)
    @template.web_layout.dup.update(web_template: new_template)
  end

  def clone_theme(new_template)
    @template.web_theme.dup.update(web_template: new_template)
  end

  def clone_drop_targets(drop_targets, new_template)
    drop_targets.each do |drop_target|
      new_drop_target = drop_target.dup.update(web_template: new_template)
      clone_widgets(drop_target.widgets, new_drop_target)
    end
  end

  def clone_widgets(widgets, drop_target)
    widgets.each { |widget| WidgetCloner.new(widget, drop_target).clone }
  end
end
