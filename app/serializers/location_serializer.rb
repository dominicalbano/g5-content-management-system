class LocationSerializer < ActiveModel::Serializer
  embed :ids, include: true

  has_one :website

  attributes  :id,
              :urn,
              :name,
              :domain,
              :corporate
end
