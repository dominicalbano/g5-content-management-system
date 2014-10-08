class WidgetDrop < Liquid::Drop
  attr_accessor :widget, :locations

  def initialize(widget, locations)
    @widget, @locations = widget, locations
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

private

  def selected_location_ids
    widget.included_locations.best_value.map(&:to_i)
  end

  def parent_setting
    @parent_setting ||= Setting.where(value: widget.id).find do |setting|
      setting.name =~ /(?=column)(?=.*widget_id).*/
    end
  end

  def client_services
    @client_services ||= ClientServices.new
  end
end

