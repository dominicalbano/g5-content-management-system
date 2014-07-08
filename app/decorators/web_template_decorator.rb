class WebTemplateDecorator < Draper::Decorator
  delegate_all

  liquid_methods :display, :title, :url, :top_level, :child_templates

  def display
    true
  end
end
