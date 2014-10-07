class LocationSerializer < ActiveModel::Serializer
  embed :ids, include: true

  has_one :website

  attributes  :id,
              :urn,
              :name,
              :domain,
              :corporate,
              :single_domain

  def single_domain
    Client.first.type == "SingleDomainClient"
  end
end
