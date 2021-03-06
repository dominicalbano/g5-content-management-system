class Location < ActiveRecord::Base
  STATUS_TYPES = ["Pending", "Live", "Suspended"]

  include HasManySettings
  include ToParamUrn
  include AfterUpdateSetSettingLocationsNavigation
  include AfterUpdateSetSettingCorporateMap
  include AfterUpdateSetPathSettings

  has_one :website, as: :owner, dependent: :destroy

  validates :uid, presence: true, uniqueness: true
  validates :urn, presence: true, uniqueness: true
  validates :name, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :status, presence: true, inclusion: { in: STATUS_TYPES, message: "%{value} is not a valid status" }

  default_scope { order("corporate DESC") }

  scope :live, -> { where(status: "Live") }
  scope :live_websites, -> { live.map(&:website) }
  scope :without_corporate, -> { where(corporate: false)}
  scope :for_area_pages, -> { live.without_corporate }

  before_validation :set_city_slug_from_city

  def self.corporate
    where(corporate: true).first
  end

  def website_id
    website.try(:id)
  end
  
  def bucket_asset_key_prefix
    "#{Client.take.bucket_asset_key_prefix}/#{urn}"
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

  def website_defaults
    HashWithIndifferentAccess.new(YAML.load_file(website_default_file))
  end

  def website_default_file
    vert = Client.take.vertical.downcase.underscore
    corp = "_corp" if corporate
    file = "#{WEBSITE_DEFAULTS_PATH}/#{vert}#{corp}_defaults.yml"
    File.exists?(file) ? file : "#{WEBSITE_DEFAULTS_PATH}/defaults.yml"
  end

  private

  def set_city_slug_from_city
    self.city_slug = city.to_s.parameterize
  end
end
