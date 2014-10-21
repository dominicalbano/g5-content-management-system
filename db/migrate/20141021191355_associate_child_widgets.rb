class AssociateChildWidgets < ActiveRecord::Migration
  def change
    Widget.all.each do |widget|
      widget.widgets.each do |child_widget|
        child_widget.update(parent: widget)
      end
    end
  end
end
