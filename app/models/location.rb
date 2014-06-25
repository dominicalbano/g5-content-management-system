class Location < ActiveRecord::Base
  include HasManySettings
  include ToParamUrn
  include AfterUpdateSetSettingLocationsNavigation

  has_one :website, as: :owner, dependent: :destroy

  validates :uid, presence: true, uniqueness: true
  validates :urn, presence: true, uniqueness: true
  validates :name, presence: true
  validates :city, presence: true
  validates :state, presence: true

  scope :corporate, -> { where(corporate: true).first }

  def website_id
    website.try(:id)
  end

  def state_slug
    state.try(:parameterize).to_s
  end

  def neighborhood_slug
    neighborhood.try(:parameterize).to_s
  end

  def city_slug
    city.try(:parameterize).to_s
  end
end
