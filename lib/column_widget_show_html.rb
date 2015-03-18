class ColumnWidgetShowHtml < LayoutWidgetShowHtml
  def render
    show_html = Liquid::Template.parse(widget.show_html).render("widget" => widget)
    @nokogiri = Nokogiri.parse(show_html)
    render_widgets
    @nokogiri.to_html
  end

  private

  def render_widgets
    render_widget("row_1_widget_id", "#drop-target-first-row")
    render_widget("row_2_widget_id", "#drop-target-second-row")  if display_two?
    render_widget("row_3_widget_id", "#drop-target-third-row") if display_three?
    render_widget("row_4_widget_id", "#drop-target-fourth-row") if display_four?
    render_widget("row_5_widget_id", "#drop-target-fifth-row")  if display_five?
    render_widget("row_6_widget_id", "#drop-target-sixth-row")  if count?("six")
  end

  def row_count
    @row_count ||= widget.settings.where(name: "row_count").first.try(:value)
  end

  def display_two?
    count?("two") || display_three?
  end

  def display_three?
    count?("three") || display_four?
  end

  def display_four?
    count?("four") || display_five?
  end

  def display_five?
    count?("five") || count?("six")
  end

  def count?(row)
    row_count == row
  end
end
