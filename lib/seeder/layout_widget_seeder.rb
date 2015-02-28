module Seeder
  class LayoutWidgetSeeder < Seeder::ModelSeeder
    attr_reader :instructions, :widget

    def initialize(widget, instructions)
      @widget = widget
      @instructions = instructions
    end

    def seed
      set_default_widget_settings(@instructions[layout_var], @instructions['widgets'])
    end

    protected

    def layout_var
      "" # abstract - do nothing
    end

    def position_var
      "" # abstract - do nothing
    end

    def set_default_widget_settings(layout, widgets)
      @widget.settings.find_by_name(layout_var).update_attributes(layout)
      widgets.each_with_index(1) do |instruction, idx|
        w = WidgetSeeder.new(nil, instruction)
        if w.valid?
          pos = position_name[idx]
          @widget.settings.find_by_name("#{position_var}_#{pos}_widget_name").update_attributes(w.name)
          @widget.settings.find_by_name("#{position_var}_#{pos}_widget_id").update_attributes(w.id)
        end
      end
    end
  end
end