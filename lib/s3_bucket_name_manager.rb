class S3BucketNameManager
  def initialize(location)
    @location = location
  end

  def asset_bucket_config_variable_name
    "AWS_S3_BUCKET_NAME_#{@location.name.parameterize.underscore.upcase}"
  end

  def asset_bucket_name
    "assets.#{@location.urn}"
  end

  def asset_bucket
    ENV[asset_bucket_config_variable_name]
  end

  def asset_bucket_config
    "#{asset_bucket_config_variable_name}=#{asset_bucket_name}"
  end
end
