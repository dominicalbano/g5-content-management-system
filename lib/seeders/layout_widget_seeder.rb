class LayoutWidgetSeeder < ModelSeeder
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
    widgets.try(:each_with_index) do |instruction, idx|
      w = WidgetSeeder.new(nil, instruction)
      if w.valid?
        pos = position_name(idx)
        @widget.settings.find_by_name("#{position_var}_#{pos}_widget_name").update_attributes(w.name)
        @widget.settings.find_by_name("#{position_var}_#{pos}_widget_id").update_attributes(w.id)
      end
    end
  end

  def position_name(index)
    case index
      when 0 return 'one'
      when 1 return 'two'
      when 2 return 'three'
      when 3 return 'four'
      when 4 return 'five'
      when 5 return 'six'
    end
  end
end