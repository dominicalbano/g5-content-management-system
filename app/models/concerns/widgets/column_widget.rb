module Widgets
  module ColumnWidget
    include Widgets::LayoutWidget

    def position_var
      "row"
    end

    def layout_var
      "row_count"
    end

    def render_show_html(preview=false)
      return ColumnWidgetShowHtml.new(self, preview).render
    end

    def layout_count_values
      {one: 1, two: 2, three: 3, four: 4, five: 5, six: 6}
    end

    def is_column?
      true
    end
  end
end