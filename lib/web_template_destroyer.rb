class WebTemplateDestroyer
  def initialize(id)
    @template = WebTemplate.find(id)
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
