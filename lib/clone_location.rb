module CloneLocation
  def self.remove_widget(w)
    begin
      w.widgets.each do |child|
        remove_widget(child)
      end
      w.destroy
    rescue
      # we tried to delete a widget that we had already deleted,
      # because of the way the w.widgets array includes all child
      # widgets, even children of children.
    end
  end

  def self.delete_web_templates(location)
    location.website.web_templates.each do |wt|
      wt.drop_targets.each do |dt|
        dt.widgets.each do |w|
          CloneLocation.remove_widget(w)
        end
        dt.destroy
      end
      wt.destroy
    end
  end

  def self.dup_widget(widget_a, widget_b)
    widget_a.settings.each do |s|
      Rails.logger.info "         #{s.name} = #{s.value}"
      unless /widget_id$/ =~ s.name # Never set the setting 'widget_id'
        widget_b.settings.where({name: s.name}).first.update({value: s.value})
        if /widget_name$/ =~ s.name # then we just created a new widget
          # Reload it so we can get the id that was created in the settings
          begin
            # Try your best
            widget_b = Widget.find(widget_b.id)
            new_widget = Widget.find(widget_b.settings.where({name: s.name.gsub('_name', '_id')}).first.value)
            orig_widget = Widget.find(widget_a.settings.where({name: s.name.gsub('_name', '_id')}).first.value)
            if s.value == 'Row' || s.value == 'Column'
              CloneLocation.dup_widget(orig_widget, new_widget)
            else
              # otherwise just clone the settings for the new widget
              orig_widget.settings.each do |s1|
                new_widget.settings.where({name: s1.name}).first.update({value: s1.value})
              end
            end
          rescue
            # Oh well
          end
        end
      end
    end
  end


  def self.clone_location(loc_a, loc_b)
    Rails.logger.info "Cloning #{loc_a.name} pages and widgets to #{loc_b.name}"
    CloneLocation.delete_web_templates(loc_b)
    loc_a.website.web_templates.each do |wt_a|
      Rails.logger.info "#{wt_a.name}"
      wt_b = wt_a.dup
      wt_b.update({website_id: loc_b.website.id})
      if wt_b.slug == 'website-template'
        web_layout_b = wt_a.web_layout.dup
        web_layout_b.update({web_template_id: wt_b.id})
        web_theme_b = wt_a.web_theme.dup
        web_theme_b.update({web_template_id: wt_b.id})
      end
      wt_a.drop_targets.each do |dt_a|
        Rails.logger.info "   #{dt_a.html_id}"
        dt_b = dt_a.dup
        dt_b.update({web_template_id: wt_b.id})
        dt_a.widgets.each do |widget_a|
          Rails.logger.info "      #{widget_a.name}"
          widget_b = widget_a.dup
          widget_b.update({drop_target_id: dt_b.id})
          CloneLocation.dup_widget(widget_a, widget_b)
        end
      end
    end
  end
end
