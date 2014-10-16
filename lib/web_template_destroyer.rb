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
    WebTemplateWidgetCollector.new(@template).collect.map(&:destroy)
  end
end
