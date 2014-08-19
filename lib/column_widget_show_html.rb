class ColumnWidgetShowHtml < LayoutWidgetShowHtml
  def render
    show_html = Liquid::Template.parse(widget.show_html).render("widget" => widget)
    @nokogiri = Nokogiri.parse(show_html)

    render_widget("row_one_widget_id", "#drop-target-first-row")

    if two_rows? or three_rows? or four_rows? or five_rows?
      render_widget("row_two_widget_id", "#drop-target-second-row")

      if three_rows? or four_rows? or five_rows?
        render_widget("row_three_widget_id", "#drop-target-third-row")

        if four_rows? or five_rows?
          render_widget("row_four_widget_id", "#drop-target-fourth-row")

          if five_rows?
            render_widget("row_five_widget_id", "#drop-target-fifth-row")
          end
        end
      end
    end

    @nokogiri.to_html
  end

  private

  def row_count
    @row_count ||= widget.settings.where(name: "row_count").first.try(:value)
  end

  def two_rows?
    row_count == "two"
  end

  def three_rows?
    row_count == "three"
  end

  def four_rows?
    row_count == "four"
  end

  def five_rows?
    row_count == "five"
  end
end
