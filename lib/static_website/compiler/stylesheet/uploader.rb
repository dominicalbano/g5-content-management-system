require "aws-sdk"

module StaticWebsite
  module Compiler
    class Stylesheet
      class Uploader
        attr_reader :from_path, :s3, :bucket_name, :bucket_url

        def initialize(from_path, location_name)
          @from_path = from_path
          @s3 = AWS::S3.new(
            access_key_id: ENV["AWS_ACCESS_KEY_ID"],
            secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
            region: ENV["AWS_REGION"] || "us-west-2"
          )
          location_name = location_name.to_s.underscore.upcase.gsub(/ /, "_")
          @bucket_name = ENV["AWS_S3_BUCKET_NAME_#{location_name}"]
          @bucket_url = ENV["AWS_S3_BUCKET_URL_#{location_name}"]
        end

        def compile
          s3_bucket_object.write(Pathname.new(from_path), write_options)
        end

        def uploaded_path
          File.join(bucket_url.to_s, to_path.to_s)
        end

        def s3_bucket
          @s3_bucket ||= if s3.buckets[bucket_name].exists?
            s3.buckets[bucket_name]
          else
            s3.buckets.create(bucket_name)
          end
        end

        def s3_bucket_object
          @s3_bucket_object ||= s3_bucket.objects[to_path]
        end

        def write_options
          { acl: :public_read, content_type: "text/css" }
        end

        def to_path
          @filename ||= File.basename(from_path)
          @to_path ||= File.join("stylesheets", @filename)
        end
      end
    end
  end
end
