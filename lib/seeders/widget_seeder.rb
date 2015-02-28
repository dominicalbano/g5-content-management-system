class WidgetSeeder < ModelSeeder
  attr_reader :instructions, :widget

  def initialize(drop_target, instructions)
    @instructions = instructions
    @drop_target = drop_target
  end

  def seed
    @widget = @drop_target ? @drop_target.widgets.create(widget_params) : Widget.create(widget_params)
    if @widget.valid?
      return ContentStripeWidgetSeeder.new(@widget, @instructions).seed if @widget.kind_of_widget?("Content Stripe")
      return ColumnWidgetSeeder.new(@widget, @instructions).seed if @widget.kind_of_widget?("Column")
      set_default_widget_settings(@instructions["settings"])
    else
      Rails.logger.debug("#{@instructions.to_s} Widget errors: #{@widget.errors.inspect}\n")
    end
  end

  private

  def set_default_widget_settings(instructions)
    instructions.try(:each) do |setting|
      set_default_widget_setting(setting)
    end
  end

  def set_default_widget_setting(setting)
    if widget_setting = @widget.settings.find_by_name(setting["name"])
      widget_setting.update_attributes(setting)
    end
  end

  def widget_params
    params_for(GardenWidget, @instructions, :garden_widget_id)
  end
end