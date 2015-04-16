class UpdateCtasWithPaths < ActiveRecord::Migration
  def up
    GardenWidgetUpdater.new.update_all(false, ['calls-to-action'])

    def update_cta_widget_settings(widget, website_slug)
      (1..4).each do |n|
        old_setting_value = widget.get_setting_value("cta_link_#{n}")
        unless old_setting_value.nil?
          if old_setting_value.split('/').last == website_slug
            new_setting_value = "home"
          else
            new_setting_value = old_setting_value.split('/').last
          end
        end
        setting = widget.get_setting("page_slug_#{n}")
        if setting
          setting.update_attribute(:value, new_setting_value)
        else
          Rails.logger.error("Could not find setting for widget: #{widget.inspect}")
          Rails.logger.error("widget settings: #{puts widget.settings.each{|s| s.inspect}}")
        end
      end
    end

    Widget.by_name('Calls To Action').each do |widget|
      website = widget.get_web_template.try(:website)
      update_cta_widget_settings(widget, website.slug) if website
    end

  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

end

