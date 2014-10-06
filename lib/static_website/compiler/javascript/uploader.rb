require "aws-sdk"

module StaticWebsite
  module Compiler
    class Javascript
      class Uploader
        attr_reader :from_paths, :s3, :bucket_name, :bucket_url, :uploaded_paths

        def initialize(from_paths, location_name)
          @from_paths = from_paths
          @location_name = location_name
          @s3 = AWS::S3.new(
            access_key_id: ENV["AWS_ACCESS_KEY_ID"],
            secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
            region: ENV["AWS_REGION"] || "us-west-2"
          )

          unless location_name.empty?
            @bucket_name = s3_bucket_name_manager.bucket
            @bucket_url = s3_bucket_name_manager.bucket_url
          end
        end

        def compile
          @uploaded_paths = []
          from_paths.each do |from_path|
            s3_bucket_object(from_path).write(Pathname.new(from_path), write_options)
            @uploaded_paths << File.join(bucket_url.to_s, to_path(from_path).to_s)
          end
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

        def to_path(from_path)
          filename = File.basename(from_path)
          to_path = File.join("javascripts", filename)
        end

        private

        def s3_bucket_name_manager
          @s3_bucket_name_manager ||= S3BucketNameManager.new(location)
        end

        def location
          Location.where(name: @location_name).first
        end
      end
    end
  end
end
