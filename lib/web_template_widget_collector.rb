class WebTemplateWidgetCollector
  def initialize(template)
    @template = template
  end

  def collect
    (top_level_widgets + top_level_widgets_children).flatten
  end

  private

  def top_level_widgets
    @top_level_widgets ||= @template.drop_targets.map(&:widgets).flatten
  end

  def top_level_widgets_children
    top_level_widgets.map(&:widgets).flatten
  end
end
