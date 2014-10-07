class LayoutWidgetShowHtml
  attr_accessor :widget

  def initialize(widget)
    @widget = widget
  end

  protected

  def find_widget(setting_name)
    id = widget.settings.where(name: setting_name).first.try(:value)
    Widget.where(id: id).first if id
  end

  def render_widget(setting_name, html_id)
    if found_widget = find_widget(setting_name)
      html_at_id = @nokogiri.at_css(html_id)
      if html_at_id
        html_at_id.inner_html = found_widget.render_show_html
      end
    end
  end
end
