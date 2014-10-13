class Location < ActiveRecord::Base
  STATUS_TYPES = ["New", "Live", "Suspended"]

  include HasManySettings
  include ToParamUrn
  include AfterUpdateSetSettingLocationsNavigation
  include AfterUpdateSetSettingCorporateMap
  include AfterUpdateSetSettingCta

  has_one :website, as: :owner, dependent: :destroy

  validates :uid, presence: true, uniqueness: true
  validates :urn, presence: true, uniqueness: true
  validates :name, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :status, presence: true, inclusion: { in: STATUS_TYPES, message: "%{value} is not a valid status" }

  scope :corporate, -> { where(corporate: true).first }
  scope :live, -> { where(status: "Live") }
  scope :live_websites, -> { live.map(&:website) }

  before_validation :set_city_slug_from_city

  def website_id
    website.try(:id)
  end

  def state_slug
    state.try(:parameterize).to_s
  end

  def neighborhood_slug
    neighborhood.try(:parameterize).to_s
  end

  def create_bucket
    BucketCreator.new(self).create
  end

  private

  def set_city_slug_from_city
    self.city_slug = city.to_s.parameterize
  end
end
