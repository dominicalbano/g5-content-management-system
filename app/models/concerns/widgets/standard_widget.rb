module Widgets
  module StandardWidget
    extend ActiveSupport::Concern

    def child_widgets
      []
    end

    def has_child_widget?(widget)
      false
    end

    def get_child_widget(position)
      nil
    end

    def set_child_widget(position, widget)
      nil
    end

    def widgets
      [] # non-layout widgets don't have child widgets
    end

    def is_layout?
      false
    end

    def is_column?
      false
    end

    def is_content_stripe?
      false
    end
  end
end