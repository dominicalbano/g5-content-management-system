class Category < ActiveRecord::Base
  validates :name, :slug, presence: true
  validates :slug, presence: true, unless: :new_record?

  before_validation :set_slug_from_name

  has_many :assets

  private

  def set_slug_from_name
    self.slug ||= name.parameterize
  end
end
