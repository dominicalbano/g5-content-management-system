class RowWidgetShowHtml < LayoutWidgetShowHtml
  def render
    widget_html = Liquid::Template.parse("<div class='widget-wrapper row-widget-wrapper' id='widget-#{widget.id}'>#{widget.show_html}</div>").render("widget" => widget)
    @nokogiri = Nokogiri.parse(widget_html)
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
    row_layout == "halves"|| row_layout == "uneven-thirds-1" || row_layout == "uneven-thirds-2"
  end

  def three_columns?
    row_layout == "thirds"
  end

  def four_columns?
    row_layout == "quarters"
  end
end
