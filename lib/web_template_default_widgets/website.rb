module WebTemplateDefaultWidgets
  class Website
    DEFAULTS = {
      "drop-target-logo" => ["logo"],
      "drop-target-phone" => ["phone"],
      "drop-target-btn" => ["button"],
      "drop-target-nav" => ["navigation"],
      "drop-target-aside" => ["calls-to-action", "social-links"],
      "drop-target-footer" => ["navigation", "contact-info", "hours"]
    }

    def initialize(website_template)
      @website_template = website_template
    end

    def create
      if @website_template.save
        create_default_widgets
      end
    end

    def create_default_widgets
      DEFAULTS.each_pair do |drop_target, widget_names|
        widget_names.each do |widget_name|
          create_default_widget(widget_name, drop_target)
        end
      end
    end

    def create_default_widget(widget_name, drop_target)
      @website_template.widgets.create(
        url: Widget.build_widget_url(widget_name),
        section: drop_target,
        removeable: false
      )
    end
  end
end