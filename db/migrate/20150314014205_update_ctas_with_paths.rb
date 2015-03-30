class UpdateCtasWithPaths < ActiveRecord::Migration
  def up
    GardenWidgetUpdater.new.update_all  

    def update_cta_widget_settings(widget, website_slug)
      (1..4).each do |n|
        old_setting_value = widget.settings.where(name: "cta_link_#{n}").first.value
        unless old_setting_value.nil?
          if old_setting_value.split('/').last == website_slug
            new_setting_value = "home"
          else
            new_setting_value = old_setting_value.split('/').last
          end
        end
        setting = widget.settings.where(name: "page_slug_#{n}").first
        if setting
          setting.update(:value => new_setting_value) if setting
        else
          Rails.logger.error("Could not find setting for widget: #{widget.inspect}")
          Rails.logger.error("widget settings: #{puts widget.settings.each{|s| s.inspect}}")
        end
      end
    end

    WebTemplate.all.each do |wpt|
      wpt.widgets.each do |widget|
        if widget.name == "Calls To Action"
          update_cta_widget_settings(widget, wpt.website.slug)
        end
        widget.widgets.each do |widget|
          if widget.name == "Calls To Action"
            update_cta_widget_settings(widget, wpt.website.slug)
          end
        end
      end
    end

  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

end

