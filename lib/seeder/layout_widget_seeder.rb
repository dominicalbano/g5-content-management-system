module Seeder
  class LayoutWidgetSeeder < Seeder::ModelSeeder
    attr_reader :instructions, :widget

    def initialize(widget, instructions)
      @widget = widget
      @instructions = instructions
    end

    def seed
      set_default_widget_settings(@instructions[layout_var], @instructions['widgets'])
      @widget
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
      return unless layout && widgets
      @widget.settings.find_by_name(layout_var).update_attribute('value', layout)
      widgets.each.with_index(1) do |instruction, idx|
        w = WidgetSeeder.new(nil, instruction)
        w.seed
        if w.widget.valid?
          pos = position_name[idx]
          @widget.settings.find_by_name("#{position_var}_#{pos}_widget_name").update_attribute('value', w.widget.name)
          @widget.settings.find_by_name("#{position_var}_#{pos}_widget_id").update_attribute('value', w.widget.id)
        end
      end
    end
  end
end