class WebsiteTemplate < WebTemplate
  def all_widgets
    widgets.not_meta_description
  end

  # TODO: remove when Ember App implements DropTarget
  def head_widgets
    drop_targets.where(html_id: "drop-target-head").first.try(:widgets)
  end

  # TODO: remove when Ember App implements DropTarget
  def logo_widgets
    drop_targets.where(html_id: "drop-target-logo").first.try(:widgets)
  end

  # TODO: remove when Ember App implements DropTarget
  def btn_widgets
    drop_targets.where(html_id: "drop-target-btn").first.try(:widgets)
  end

  # TODO: remove when Ember App implements DropTarget
  def nav_widgets
    drop_targets.where(html_id: "drop-target-nav").first.try(:widgets)
  end

  # TODO: remove when Ember App implements DropTarget
  def footer_widgets
    drop_targets.where(html_id: "drop-target-footer").first.try(:widgets)
  end

  # TODO: remove when Ember App implements DropTarget
  def aside_before_main_widgets
    drop_targets.where(html_id: "drop-target-aside-before-main").first.try(:widgets)
  end

  # TODO: remove when Ember App implements DropTarget
  def aside_after_main_widgets
    drop_targets.where(html_id: "drop-target-aside-after-main").first.try(:widgets)
  end

  def stylesheets
    widget_stylesheets + layout_stylesheets
  end

  def layout_stylesheets
    local_stylesheets +
      web_layout_stylesheets +
      web_theme_stylesheets
  end

  def local_stylesheets
    [File.join(Rails.root, "app", "views", "web_templates", "stylesheets.scss")]
  end

  def web_layout_stylesheets
    web_layout ? web_layout.stylesheets : []
  end

  def web_theme_stylesheets
    web_theme ? web_theme.stylesheets : []
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
    web_theme ? web_theme.javascripts : []
  end

  def colors
    web_theme.try(:display_colors)
  end
end
