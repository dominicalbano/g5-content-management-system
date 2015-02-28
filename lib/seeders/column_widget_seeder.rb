class ColumnWidgetSeeder < ModelSeeder
  attr_reader :instructions, :widget

  def initialize(widget, instructions)
    @widget = widget
    @instructions = instructions
  end

  def seed
    set_default_widget_settings(@instructions['row_count'], @instructions['widgets'])
  end

  private 

  def set_default_widget_settings(row_count, widgets)
    @widget.settings.find_by_name('row_count').update_attributes(row_count)
    widgets.try(:each_with_index) do |instruction, idx|
      w = WidgetSeeder.new(nil, instruction)
      if w.valid?
        row = column_name(idx)
        @widget.settings.find_by_name("row_#{row}_widget_name").update_attributes(w.name)
        @widget.settings.find_by_name("row_#{row}_widget_id").update_attributes(w.id)
      end
    end
  end

  private

  def row_name(index)
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