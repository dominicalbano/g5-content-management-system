class LayoutWidgetShowHtml
  attr_accessor :widget

  def initialize(widget)
    @widget = widget
  end

  def render
    return unless widget.is_layout?
    show_html = Liquid::Template.parse(widget.show_html).render("widget" => widget)
    @nokogiri = Nokogiri.parse(show_html)
    render_widgets
    @nokogiri.to_html
  end

  protected

  def find_widget(setting_name)
    id = widget.get_setting_value(setting_name)
    Widget.find(id) if id
  end

  def render_widgets
    (1..widget.max_widgets).each do |idx|
      render_widget("#{widget.child_widget_setting_prefix(idx)}id", "#drop-target-#{idx}-#{widget.layout_var}-{widget.id}")
    end
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

