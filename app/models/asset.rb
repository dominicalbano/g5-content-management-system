class Asset < ActiveRecord::Base

  validates :url, presence: true, uniqueness: true
  validates :category_id, presence: true

  belongs_to :website
  belongs_to :category

end
