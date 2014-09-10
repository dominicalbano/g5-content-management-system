class LocationBucketCreator
  def initialize(location)
    @location = location
  end

  def create
    return if config_exists?

    create_bucket
    set_config
  end

  private

  def create_bucket
    s3_client.buckets.create(bucket_name)
  end

  def config_exists?
    JSON.parse(heroku_client.get_config_vars).has_key?(config_var)
  end

  def set_config
    heroku_client.set_config(config_var, bucket_name)
  end

  def bucket_name
    s3_bucket_name_manager.asset_bucket_name
  end

  def config_var
    s3_bucket_name_manager.asset_bucket_config_variable_name
  end

  def s3_client
    AWS::S3.new(
      access_key_id: ENV["AWS_ACCESS_KEY_ID"],
      secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
      region: ENV["AWS_REGION"] || "us-west-2"
    )
  end

  def heroku_client
    @heroku_client ||= HerokuClient.new(ClientServices.new.cms_app_name)
  end

  def s3_bucket_name_manager
    @s3_bucket_name_manager ||= S3BucketNameManager.new(@location)
  end
end
