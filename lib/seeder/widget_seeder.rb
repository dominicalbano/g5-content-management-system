module Seeder
  class WidgetSeeder < Seeder::ModelSeeder
    attr_reader :instructions, :drop_target, :widget

    def initialize(drop_target, instructions)
      @instructions = instructions
      @drop_target = drop_target
    end

    def seed
      return nil unless @instructions
      @widget = @drop_target ? @drop_target.widgets.create(widget_params) : Widget.create(widget_params)
      return widget_seeder_error("Invalid widget params") unless @widget.try(:valid?)
      begin
        return ContentStripeWidgetSeeder.new(@widget, @instructions).seed if @widget.is_content_stripe?
        return ColumnWidgetSeeder.new(@widget, @instructions).seed if @widget.is_column?
        set_default_widget_settings(@instructions[:settings])
      rescue => e
        binding.pry
        widget_seeder_error(e)
      end
      @widget
    end

    private

    def set_default_widget_settings(instructions)
      instructions.try(:each) { |setting| set_default_widget_setting(setting) }
    end

    def set_default_widget_setting(setting)
      widget_setting = @widget.settings.find_by_name(setting[:name])
      widget_setting.update_attribute('value', setting[:value]) if widget_setting
    end

    def widget_params
      params_for(GardenWidget, @instructions, :garden_widget_id)
    end

    def widget_seeder_error(error)
      Rails.logger.debug("ERROR: #{error} - Instructions: #{@instructions}\n")
      @widget.try(:destroy)
      @widget = nil
    end
  end
end