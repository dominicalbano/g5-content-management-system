class WebsiteFinder::Widget < WebsiteFinder::Base
  def find
    if @object.drop_target.nil?
      layout_setting.owner.drop_target.web_template.website
    else
      @object.drop_target.web_template.website
    end
  end
end
