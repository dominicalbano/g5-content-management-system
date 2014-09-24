class ClientSerializer < ActiveModel::Serializer
  embed :ids, include: true
  
  attributes  :id,
              :urn,
              :name,
              :url,
              :location_urns,
              :location_urls,
              :cms_urn,
              :cms_url,
              :cpns_urn,
              :cpns_url,
              :cpas_urn,
              :cpas_url,
              :cls_urn,
              :cls_url,
              :cxm_urn,
              :cxm_url,
              :single_domain

  def url
    client_services.client_url
  end

  def location_urns
    client_services.client_location_urns
  end

  def location_urls
    client_services.client_location_urls
  end

  def single_domain
    object.type == "SingleDomainClient"
  end

  ClientServices::SERVICES.each do |service|
    define_method("#{service}_urn") do
      client_services.send(:"#{service}_urn")
    end

    define_method("#{service}_url") do
      client_services.send(:"#{service}_url")
    end
  end

  private

  def client_services
    @client_services ||= ClientServices.new
  end
end
