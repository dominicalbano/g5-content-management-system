class RowWidgetShowHtml < LayoutWidgetShowHtml
  def render
    show_html = Liquid::Template.parse(widget.show_html).render("widget" => widget)
    @nokogiri = Nokogiri.parse(show_html)
    render_widget("column_one_widget_id", "#drop-target-first-col")
    if two_columns? or three_columns? or four_columns?
      render_widget("column_two_widget_id", "#drop-target-second-col")
      if three_columns? or four_columns?
        render_widget("column_three_widget_id", "#drop-target-third-col")
        if four_columns?
          render_widget("column_four_widget_id", "#drop-target-fourth-col")
        end
      end
    end
    @nokogiri.to_html
  end

  private

  def row_layout
    @row_layout ||= widget.settings.where(name: "row_layout").first.try(:value)
  end

  def two_columns?
    row_layout == "halves"|| row_layout == "thirds-1" || row_layout == "thirds-2"
  end

  def three_columns?
    row_layout == "thirds"
  end

  def four_columns?
    row_layout == "quarters"
  end
end
