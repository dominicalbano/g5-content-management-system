require "aws-sdk"

module StaticWebsite
  module Compiler
    class Uploader
      def initialize(from_paths, location_name)
        @from_paths = Array(from_paths)
        @location_name = location_name
        @s3 = BucketCreator::s3_client
        initialize_bucket_name_manager
      end

      def initialize_bucket_name_manager
        unless @location_name.empty?
          @bucket_name = s3_bucket_name_manager.bucket_name
          @bucket_url = s3_bucket_name_manager.bucket_url
        end
      end

      def s3_bucket
        @s3_bucket ||= s3.buckets[@bucket_name].exists? ? s3.buckets[@bucket_name] : s3.buckets.create(@bucket_name)
      end

      def s3_bucket_object
        @s3_bucket_object ||= s3_bucket.objects[to_path]
      end

      def compile
        write_to_loggers("Writing assets to S3")
        @uploaded_paths = from_paths.inject([]) do |arr, from_path|
          arr << s3_bucket_update(from_path, write_options)
          arr
        end
      end

      def data_type
        raise NotImplementedError
      end

      def data_dir
        raise NotImplementedError
      end

      def write_options
        {:acl => :public_read, :content_type => "text/#{data_type}", metadata: {"x-amz-meta-freshness" => "current"}}
      end

      def to_path(from_path)
        File.join("#{location.bucket_asset_key_prefix}/#{data_dir}", File.basename(from_path))
      end

      protected

      def s3_bucket_name_manager
        @s3_bucket_name_manager ||= S3BucketNameManager.new(location)
      end

      def s3_bucket_update(from_path, write_options)
        path = Pathname.new(from_path)
        write_to_loggers("writing to bucket\n#{from_path.to_s}\n#{path.to_s}\n#{write_options.to_s}")
        result = s3_bucket_object(from_path).write(path, write_options)
        write_to_loggers(result.inspect)
        File.join(@bucket_url.to_s, to_path(from_path).to_s)
      end

      def location
        @location ||= Location.where(name: @location_name).first
      end
    end
  end
end
