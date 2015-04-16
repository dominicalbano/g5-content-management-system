module Seeder
  class LayoutWidgetSeeder < Seeder::ModelSeeder
    attr_reader :instructions, :widget

    def initialize(widget, instructions)
      @widget = widget
      @instructions = instructions
    end

    def seed
      Rails.logger.debug("Creating #{@widget.name} widget from instructions")
      set_default_widget_settings(@instructions[@widget.layout_var], @instructions[:widgets], @instructions[css_custom_var])
    end

    protected

    def css_custom_var
      'row_css_custom'
    end

    def set_default_widget_settings(layout, widget_instructions, custom_css="")
      return @widget unless layout && widget_instructions
      @widget.set_setting(@widget.layout_var, layout)
      @widget.set_setting(css_custom_var, custom_css) unless custom_css.blank?
      
      widget_instructions.each.with_index(1) do |instruction, idx|
        w = WidgetSeeder.new(nil, instruction).seed
        @widget.set_child_widget(idx, w) if w.try(:valid?)
      end
      @widget.reload
    end
  end
end