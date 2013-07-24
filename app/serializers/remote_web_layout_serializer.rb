class RemoteWebLayoutSerializer < ActiveModel::Serializer
  attributes  :id,
              :name,
              :thumbnail,
              :url

  def id
    object.name
  end
end
