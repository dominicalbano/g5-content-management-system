class WebsiteFinder::Widget < WebsiteFinder::Base
  def find
    get_drop_target(@object).try(:web_template).try(:website)
  end

  def find_parent(widget)
    layout_setting_for(widget).try(:owner)
  end

  def get_drop_target(widget)
    if widget.drop_target
      widget.drop_target
    else # find parent
      parent = find_parent(widget)
      get_drop_target(parent) if parent
    end
  end
end
