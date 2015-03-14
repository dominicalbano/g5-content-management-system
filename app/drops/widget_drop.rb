class WidgetDrop < Liquid::Drop
  attr_accessor :widget, :locations, :preview

  def initialize(widget, locations, preview=false)
    @widget, @locations, @preview = widget, locations, preview
  end

  def client_locations
    locations.map(&:decorate)
  end

  def before_method(method)
    setting = widget.settings.find_by(name: method)
    setting.try(:decorate)
  end

  def addresses
    Location.where(id: selected_location_ids).map(&:decorate).
                                              map(&:address).to_json
  end

  def id
    widget.id
  end

  def parent_widget_id
    parent_setting.owner.id if parent_setting
  end

  ClientServices::SERVICES.each do |service|
    delegate :"#{service}_url", to: :client_services

    define_method :"secure_#{service}_url" do
      client_services.send(:"#{service}_url", secure: true)
    end
  end

  def corporate_navigation
    CorporateNavigationSetting.new.value
  end

  def navigateable_pages
    pages = [WebsiteFinder::Widget.new(widget).find.web_page_templates.navigateable.rank(:display_order).all,
             WebsiteFinder::Widget.new(widget).find.web_home_template].flatten
    pages.map {|page| template_to_liquid(page)}
  end
  
  def url_get_method
    preview ? :preview_url : :url
  end

  def generated_url_1
    WebTemplate.where(slug: widget.page_slug_1.value).first.send(url_get_method)
  end

  def generated_url_2
    WebTemplate.where(slug: widget.page_slug_2.value).first.send(url_get_method)
  end

  def generated_url_3
    WebTemplate.where(slug: widget.page_slug_3.value).first.send(url_get_method)
  end

  def generated_url_4
    WebTemplate.where(slug: widget.page_slug_4.value).first.send(url_get_method)
  end

private

  def template_to_liquid(web_template)
    liquid_hash = HashWithToLiquid.new
    liquid_hash["url"] = web_template.url
    liquid_hash["preview_url"] = web_template.preview_url
    liquid_hash["slug"] = web_template.slug
    liquid_hash
  end

  def selected_location_ids
    widget.included_locations.best_value.map(&:to_i)
  end

  def parent_setting
    @parent_setting ||= Setting.where("value LIKE '%?%'", widget.id).find do |setting|
      setting.name =~ /(?=(column|row))(?=.*widget_id).*/
    end
  end

  def client_services
    @client_services ||= ClientServices.new
  end
end
