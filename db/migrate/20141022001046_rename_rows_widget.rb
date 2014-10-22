class RenameRowsWidget < ActiveRecord::Migration
  def change
    row_widget = GardenWidget.find_by_slug('row')
    row_widget.update(name: 'Content Slice', slug: 'content-slice') if row_widget
  end
end
