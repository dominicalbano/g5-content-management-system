class AddCategoryIdToAssets < ActiveRecord::Migration
  def change
    category = Category.find_by_name("Photo Gallery")
    add_column :assets, :category_id, :integer, default: category.id
  end
end
