class SetDefaultCategories < ActiveRecord::Migration
  DEFAULT_CATEGORIES = ["Photo Gallery", "Site Photo", "Hero Image", "Logo"]

  def change
    DEFAULT_CATEGORIES.each do |category|
      Category.create!(name: category)
    end
  end
end
