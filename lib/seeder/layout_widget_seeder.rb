module Seeder
  class LayoutWidgetSeeder < Seeder::ModelSeeder
    attr_reader :instructions, :widget

    def initialize(widget, instructions)
      @widget = widget
      @instructions = instructions
    end

    def seed
      set_default_widget_settings(@instructions[layout_var], @instructions[:widgets])
    end

    protected

    def layout_var
      "" # abstract - do nothing
    end

    def position_var
      "" # abstract - do nothing
    end

    def position_name
      { 1 => 'one', 2 => 'two', 3 => 'three', 4 => 'four', 5 => 'five', 6 => 'six' }
    end

    def set_default_widget_settings(layout, widgets)
      return @widget unless layout && widgets
      @widget.settings.find_by_name(layout_var).try(:update_attribute, 'value', layout)
      widgets.each.with_index(1) do |instruction, idx|
        set_nested_widget_settings(WidgetSeeder.new(nil, instruction).seed, idx)
      end
      @widget.reload
    end

    def set_nested_widget_settings(widget, index)
      if widget.try(:valid?)
        pos = position_name[index]
        @widget.settings.find_by_name("#{position_var}_#{pos}_widget_name").try(:update_attribute, 'value', widget.name)
        @widget.settings.find_by_name("#{position_var}_#{pos}_widget_id").try(:update_attribute, 'value', widget.id)
      end
    end
  end
end