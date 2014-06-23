class RowWidgetAssetCollector
  def initialize(template)
    @template = template
  end

  def javascripts
    return [] unless row_widget.present?
    [javascripts_for(row_widget_widgets) + javascripts_for(column_widget_widgets)].flatten.uniq
  end

  def stylesheets
    return [] unless row_widget.present?
    [stylesheets_for(row_widget_widgets) + stylesheets_for(column_widget_widgets)].flatten.uniq
  end

private

  def javascripts_for(widgets)
    (widgets.map(&:lib_javascripts) + widgets.map(&:show_javascripts)).flatten.compact
  end

  def stylesheets_for(widgets)
    widgets.map(&:show_stylesheets).flatten.compact
  end

  def widget_for(widgets, type)
    widgets.joins(:garden_widget).where("garden_widgets.name = ?", type).first
  end

  def widget_ids_for(settings, type)
    pattern = /(?=.*#{type})(?=.*widget_id).*/
    settings.select { |setting| setting.name =~ pattern }.map(&:value).compact
  end

  def row_widget_widget_ids
    widget_ids_for(row_widget.settings, "column")
  end

  def column_widget_widget_ids
    widget_ids_for(column_widget.settings, "row")
  end

  def row_widget
    @row_widget ||= widget_for(@template.widgets, "Row")
  end

  def column_widget
    @column_widget ||= widget_for(row_widget_widgets, "Column")
  end

  def row_widget_widgets
    @row_widget_widgets ||= Widget.where(id: row_widget_widget_ids)
  end

  def column_widget_widgets
    return [] unless column_widget.present?
    @column_widget_widgets ||= Widget.where(id: column_widget_widget_ids)
  end
end
