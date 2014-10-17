class Client < ActiveRecord::Base
  include HasManySettings

  validates :uid, presence: true, uniqueness: true
  validates :name, presence: true
  validates :vertical, presence: true
  validates :type, presence: true

  def urn
    uid.split("/").last
  end

  def bucket_asset_key_prefix
    urn
  end

  def locations
    Location.all
  end

  def vertical_slug
    vertical.try(:parameterize).to_s
  end

  def deploy
    ClientDeployerJob.perform
  end

  def async_deploy
    Resque.enqueue(ClientDeployerJob)
  end

  def website_defaults
    case vertical
    when 'Assisted-Living'
      WEBSITE_DEFAULTS_ASSISTED_LIVING
    when 'Apartments'
      WEBSITE_DEFAULTS_APARTMENTS
    when 'Self-Storage'
      WEBSITE_DEFAULTS_SELF_STORAGE
    else
      WEBSITE_DEFAULTS
    end
  end

  def create_bucket
    BucketCreator.new(self).create
  end

end

