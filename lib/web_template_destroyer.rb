class WebTemplateDestroyer
  def initialize(template)
    @template = template
  end

  def destroy
    destroy_widgets
    @template.destroy
  end

  private

  def destroy_widgets
    widgets.map(&:destroy)
  end

  def widgets
    WebTemplateWidgetCollector.new(@template).collect
  end
end
