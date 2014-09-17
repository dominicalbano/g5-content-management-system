#require "aws-sdk"

class CmsSaveManager
  attr_reader :from_paths, :s3, :bucket_name, :bucket_url, :uploaded_paths

  def initialize(client)
    @s3 = AWS::S3.new(
      access_key_id: ENV["AWS_ACCESS_KEY_ID"],
      secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
      region: ENV["AWS_REGION"] || "us-west-2"
    )
    client_name = client.name.to_s.parameterize.underscore.upcase

    #TODO change this to an env variable V
    @bucket_name = "g5-heroku-pgbackups-archive"
    @bucket_url = ENV["AWS_S3_BUCKET_URL_#{client_name}"]
  end

  def s3_bucket
    @s3_bucket ||= if s3.buckets[bucket_name].exists?
      s3.buckets[bucket_name]
    else
      s3.buckets.create(bucket_name)
    end
  end

  def s3_bucket_object(from_path)
    s3_bucket.objects[to_path(from_path)]
  end

  def write_options
    { acl: :public_read, content_type: "text/javascript" }
  end

end

