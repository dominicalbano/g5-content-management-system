class WidgetDrop < Liquid::Drop
  attr_accessor :widget, :locations

  def initialize(widget, locations)
    @widget, @locations = widget, locations
  end

  def client_locations
    locations.map(&:decorate)
  end

  def before_method(method)
    # look up setting from widget's Settings first
    setting = widget.get_setting(method)
    # create faux setting for widget drop to access liquid parameters if it exists
    unless setting
      result = widget.get_liquid_parameter(method)
      setting = Setting.new(name: method, value: result, owner: widget) if result
    end
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

private

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
