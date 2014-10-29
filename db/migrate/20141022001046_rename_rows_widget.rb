class RenameRowsWidget < ActiveRecord::Migration
  def change
    row_widget = GardenWidget.find_by_slug('row')
    row_widget.update(name: 'Content Stripe', slug: 'content-stripe') if row_widget
  end
end
