class S3BucketNameManager
  def initialize(owner)
    @owner = owner
  end

  def bucket_config_variable_url
    "AWS_S3_BUCKET_URL_#{@owner.urn.parameterize.underscore.upcase}"
  end

  def bucket_config_variable_name_based_url
    "AWS_S3_BUCKET_URL_#{@owner.name.parameterize.underscore.upcase}"
  end

  def bucket_config_variable_name
    "AWS_S3_BUCKET_NAME_#{@owner.urn.parameterize.underscore.upcase}"
  end

  def bucket_config_variable_name_based_name
    "AWS_S3_BUCKET_NAME_#{@owner.name.parameterize.underscore.upcase}"
  end

  def bucket_name
    "assets.#{@owner.urn}"
  end

  def bucket
    ENV[bucket_config_variable_name] || ENV[bucket_config_variable_name_based_name]
  end

  def bucket_url
    ENV[bucket_config_variable_url] || ENV[bucket_config_variable_name_based_url]
  end

  def bucket_config
    "#{bucket_config_variable_name}=#{bucket_name}"
  end
end
