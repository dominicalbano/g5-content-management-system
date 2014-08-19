class ColumnWidgetShowHtml < LayoutWidgetShowHtml
  def render
    show_html = Liquid::Template.parse(widget.show_html).render("widget" => widget)
    @nokogiri = Nokogiri.parse(show_html)

    render_widget("row_one_widget_id", "#drop-target-first-row")
    render_widget("row_two_widget_id", "#drop-target-second-row")  if display_two?
    render_widget("row_three_widget_id", "#drop-target-third-row") if display_three?
    render_widget("row_four_widget_id", "#drop-target-fourth-row") if display_four?
    render_widget("row_five_widget_id", "#drop-target-fifth-row")  if display_five?

    @nokogiri.to_html
  end

  private

  def row_count
    @row_count ||= widget.settings.where(name: "row_count").first.try(:value)
  end

  def display_two?
    row_count == "two" || row_count == "three" || row_count == "four" || row_count == "five"
  end

  def display_three?
    row_count == "three" || row_count == "four" || row_count == "five"
  end

  def display_four?
    row_count == "four" || row_count == "five"
  end

  def display_five?
    row_count == "five"
  end
end
