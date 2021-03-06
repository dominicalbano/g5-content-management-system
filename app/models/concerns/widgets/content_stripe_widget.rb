module Widgets
  module ContentStripeWidget
    include Widgets::LayoutWidget

    def position_var
      "column"
    end

    def layout_var
      "row_layout"
    end

    def render_show_html(preview=false)
      ContentStripeWidgetShowHtml.new(self, preview).render
    end

    def layout_count_values
      {
        single: 1, 
        halves: 2, 
        uneven_thirds_1: 2, 
        uneven_thirds_2: 2, 
        thirds: 3,
        quarters: 4
      }
    end

    def is_content_stripe?
      true
    end

    def parent_content_stripe
      nil
    end
  end
end