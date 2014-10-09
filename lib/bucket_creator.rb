class BucketCreator
  def initialize(owner)
    @owner = owner
  end

  def create
    return if config_exists?

    begin
      create_bucket
      set_config
    rescue
      false
    end
  end

  private

  def create_bucket
    begin
      s3_client.buckets.create(bucket_name)
    rescue => e
      Rails.logger.warn e.message
    end
  end

  def config_exists?
    JSON.parse(heroku_client.get_config_vars).has_key?(config_var)
  end

  def set_config
    heroku_client.set_config(config_var, bucket_name)
  end

  def bucket_name
    s3_bucket_name_manager.bucket_name
  end

  def config_var
    s3_bucket_name_manager.heroku_config_key_for_bucket_name
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
    @s3_bucket_name_manager ||= S3BucketNameManager.new(@owner)
  end
end

