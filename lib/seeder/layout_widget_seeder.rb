module Seeder
  class LayoutWidgetSeeder < Seeder::ModelSeeder
    attr_reader :instructions, :widget

    def initialize(widget, instructions)
      @widget = widget
      load_instructions(instructions)
    end

    def seed
      set_default_widget_settings(@instructions[@widget.layout_var], @instructions[:widgets])
    end

    def yaml_file_path
      CONTENT_STRIPE_DEFAULTS_PATH
    end

    protected

    def set_default_widget_settings(layout, widget_instructions)
      return @widget unless layout && widget_instructions
      @widget.set_setting(@widget.layout_var, layout)
      widget_instructions.each.with_index(1) do |instruction, idx|
        w = WidgetSeeder.new(nil, instruction).seed
        @widget.set_child_widget(idx, w) if w.try(:valid?)
      end
      @widget.reload
    end
  end
end