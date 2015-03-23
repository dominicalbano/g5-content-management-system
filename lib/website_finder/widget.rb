class WebsiteFinder::Widget < WebsiteFinder::Base
  def find
    if @object.drop_target.nil?
      if setting = layout_setting_for(@object.id)
        setting.owner.drop_target.web_template.website
      end
    else
      @object.drop_target.web_template.website
    end
  end
end
