module Widgets
  module LayoutWidget
    extend ActiveSupport::Concern

    def child_widgets
      widget_settings.map(&:value).map { |id| Widget.find(id) if Widget.exists?(id) }.compact
    end

    def has_child_widget?(widget)
      widget_settings.map(&:value).include?(widget.id)
    end

    def child_widget_setting_prefix(position)
      "#{position_var}_#{position}_widget_"
    end

    def set_child_widget(position, widget)
      return unless is_layout? && widget
      prefix = child_widget_setting_prefix(position)
      set_setting("#{prefix}name", widget.name)
      set_setting("#{prefix}id", widget.id)
    end

    def get_child_widget(position)
      child_id = get_setting_value("#{child_widget_setting_prefix(position)}id") if position <= max_widgets
      Widget.find_by_id(child_id) if child_id
    end

    def widgets
      more_widgets = child_widgets.collect { |widget| widget.try(:widgets) }
      [child_widgets, more_widgets].flatten.compact
    end

    def nested_settings
      widgets.collect {|widget| widget.settings}.flatten
    end

    def position_var
      "" # abstract
    end

    def layout_var
      "" # abstract
    end

    def is_layout?
      true
    end

    def max_widgets
      layout_sym = get_setting_value(layout_var).try(:underscore).try(:to_sym)
      layout_count_values.has_key?(layout_sym) ? layout_count_values[layout_sym] : 1
    end

    def layout_count_values
      {} # abstract
    end
  end
end