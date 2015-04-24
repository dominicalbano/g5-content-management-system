class WebsiteTemplate < WebTemplate
  def all_widgets
    widgets.not_meta_description
  end

  def widgets_for_drop_target_type(html_id)
    drop_targets.where(html_id: "drop-target-#{html_id}").first.try(:widgets) || []
  end

  # TODO: remove when Ember App implements DropTarget
  def head_widgets
    widgets_for_drop_target_type('head')
  end

  # TODO: remove when Ember App implements DropTarget
  def logo_widgets
    widgets_for_drop_target_type('logo')
  end

  # TODO: remove when Ember App implements DropTarget
  def btn_widgets
    widgets_for_drop_target_type('btn')
  end

  # TODO: remove when Ember App implements DropTarget
  def nav_widgets
    widgets_for_drop_target_type('nav')
  end

  # TODO: remove when Ember App implements DropTarget
  def footer_widgets
    widgets_for_drop_target_type('footer')
  end

  # TODO: remove when Ember App implements DropTarget
  def aside_before_main_widgets
    widgets_for_drop_target_type('aside-before-main')
  end

  # TODO: remove when Ember App implements DropTarget
  def aside_after_main_widgets
    widgets_for_drop_target_type('aside-after-main')
  end

  def stylesheets
    widget_stylesheets + layout_stylesheets
  end

  def layout_stylesheets
    local_stylesheets + web_layout_stylesheets + web_theme_stylesheets
  end

  def local_stylesheets
    [File.join(Rails.root, "app", "views", "web_templates", "stylesheets.scss")]
  end

  def web_layout_stylesheets
    web_layout.try(:stylesheets) || []
  end

  def web_theme_stylesheets
    web_theme.try(:stylesheets) || []
  end

  def widget_stylesheets
    widgets ? widgets.map(&:show_stylesheets).flatten : []
  end

  def javascripts
    widget_lib_javascripts + web_theme_javascripts + widget_show_javascripts
  end

  def widget_show_javascripts
    widgets ? widgets.map(&:show_javascripts).flatten : []
  end

  def widget_lib_javascripts
    widgets ? widgets.map(&:lib_javascripts).flatten : []
  end

  def web_theme_javascripts
    web_theme.try(:javascripts) || []
  end

  def colors
    web_theme.try(:display_colors)
  end

  def fonts
    web_theme.try(:display_fonts)
  end
end
