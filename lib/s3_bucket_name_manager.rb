class S3BucketNameManager
  BUCKET_URL = "https://s3-us-west-2.amazonaws.com/g5-orion-clients"
  BUCKET_NAME = "g5-orion-clients"

  def initialize(owner)
    @owner = owner
  end

  def heroku_config_key_for_bucket_url
    "S3_BUCKET_URL"
  end

  def heroku_config_key_for_bucket_name
    "S3_BUCKET_NAME"
  end

  def bucket_asset_key_prefix #bucket_name
    "#{Client.take.urn}/#{@owner.urn}"
  end

  def bucket_name
    BUCKET_NAME
  end

  def bucket_url
    BUCKET_URL
  end

  def heroku_bucket_config#bucket_config
    "#{heroku_config_key_for_bucket_name}=#{bucket_name}"
  end
end

