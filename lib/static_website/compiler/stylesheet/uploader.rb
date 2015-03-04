require "aws-sdk"

module StaticWebsite
  module Compiler
    class Stylesheet
      class Uploader
        attr_reader :from_path, :s3, :bucket_name, :bucket_url

        def initialize(from_path, location_name)
          LOGGERS.each{|logger| logger.debug("Initializing StaticWebsite::Compiler::Stylesheet::Uploader with from_path: \n#{from_path}\n, location_name: #{location_name}")}
          @from_path = from_path
          @location_name = location_name
          @s3 = AWS::S3.new(
            access_key_id: ENV["AWS_ACCESS_KEY_ID"],
            secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
            region: ENV["AWS_REGION"] || "us-west-2"
          )

          unless @location_name.empty?
            @bucket_name = s3_bucket_name_manager.bucket_name
            @bucket_url = s3_bucket_name_manager.bucket_url
          end
        end

        def compile
          LOGGERS.each{|logger| logger.debug("Writing style assets to S3")}
          #write with a metadata flag of status: current
          result = s3_bucket_object.write(Pathname.new(from_path), write_options)
          LOGGERS.each{|logger| logger.debug(result.inspect)}
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
          {:acl => :public_read, :content_type => "text/css",
           metadata: {"x-amz-meta-freshness" => "current"}}
        end

        def to_path
          @filename ||= File.basename(from_path)
          @to_path ||= File.join("#{location.bucket_asset_key_prefix}/stylesheets", @filename)
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
