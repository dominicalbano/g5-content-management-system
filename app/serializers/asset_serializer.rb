class AssetSerializer < ActiveModel::Serializer
  attributes  :id, :url, :category_id, :category_name

  def category_name
    object.category.name
  end
end

