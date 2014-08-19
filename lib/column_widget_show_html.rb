class ColumnWidgetShowHtml < LayoutWidgetShowHtml
  def render
    show_html = Liquid::Template.parse(widget.show_html).render("widget" => widget)
    @nokogiri = Nokogiri.parse(show_html)

    render_widget("row_one_widget_id", "#drop-target-first-row")
    render_widget("row_two_widget_id", "#drop-target-second-row")  if display_two?
    render_widget("row_three_widget_id", "#drop-target-third-row") if display_three?
    render_widget("row_four_widget_id", "#drop-target-fourth-row") if display_four?
    render_widget("row_five_widget_id", "#drop-target-fifth-row")  if count?("five")

    @nokogiri.to_html
  end

  private

  def row_count
    @row_count ||= widget.settings.where(name: "row_count").first.try(:value)
  end

  def display_two?
    count?("two") || count?("three") || count?("four") || count?("five")
  end

  def display_three?
    count?("three") || count?("four") || count?("five")
  end

  def display_four?
    count?("four") || count?("five")
  end

  def count?(row)
    row_count == row
  end
end
