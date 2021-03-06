class Asset < ActiveRecord::Base

  validates :url, presence: true, uniqueness: true
  validates :category_id, presence: true

  belongs_to :website
  belongs_to :category

  before_validation :set_default_category

  private

  def set_default_category
    self.category ||= Category.find_or_create_by(name: "Photo Gallery")
  end

end
