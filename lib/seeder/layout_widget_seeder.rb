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
      @widget.set_setting(layout_var, layout)
      widgets.each.with_index(1) do |instruction, idx|
        w = WidgetSeeder.new(nil, instruction).seed
        @widget.set_child_widget(idx, w) if w.valid?
      end
      @widget.reload
    end
  end
end