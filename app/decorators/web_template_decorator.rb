class WebTemplateDecorator < Draper::Decorator
  delegate_all

  liquid_methods :display, :title, :url

  def display
    true
  end
end
