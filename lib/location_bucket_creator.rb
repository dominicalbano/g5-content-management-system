class LocationBucketCreator
  def initialize(location)
    @location = location
  end

  def create
    create_bucket
    set_config
  end

  private

  def create_bucket
    s3.buckets.create(bucket_name)
  end

  def set_config
    HerokuClient.new(app_name).set_config(config_var, bucket_name)
  end

  def location_name_manager
    @location_name_manager ||= LocationNameManager.new(@location.name)
  end

  def bucket_name
    location_name_manager.asset_bucket_name
  end

  def config_var
    location_name_manager.asset_bucket_config_variable_name
  end

  def app_name
    ClientServices.new.cms_app_name
  end

  def s3
    @s3 ||= AWS::S3.new(
      access_key_id: ENV["AWS_ACCESS_KEY_ID"],
      secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
      region: ENV["AWS_REGION"] || "us-west-2"
    )
  end
end
