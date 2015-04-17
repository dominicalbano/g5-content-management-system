require "aws-sdk"

module StaticWebsite
  module Compiler
    class Javascript
      class Uploader
        attr_reader :from_paths, :s3, :bucket_name, :bucket_url, :uploaded_paths

        def initialize(from_paths, location_name)
          @from_paths = Array(from_paths)
          write_to_loggers("\n\nInitializing StaticWebsite::Compiler::Javascript::Uploader with from_paths: #{Array(from_paths).join("\n\t").prepend("\n\t")},\n\tlocation_name: #{location_name}\n")
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
          write_to_loggers("Writing js assets to S3")
          @uploaded_paths = from_paths.inject([]) do |arr, from_path|
            arr << s3_bucket_update(from_path, path, write_options)
            arr
          end
        end

        def s3_bucket
          @s3_bucket ||= s3.buckets[bucket_name].exists? ? s3.buckets[bucket_name] : s3.buckets.create(bucket_name)
        end

        def s3_bucket_object(from_path)
          s3_bucket.objects[to_path(from_path)]
        end

        def write_options
          {:acl => :public_read, :content_type => "text/javascript", metadata: {"x-amz-meta-freshness" => "current"}}
        end

        def to_path(from_path)
          filename = File.basename(from_path)
          to_path = File.join("#{location.bucket_asset_key_prefix}/javascripts", filename)
        end

        private

        def s3_bucket_update(from_path, path, write_options)
          path = Pathname.new(from_path)
          write_compile_path_to_loggers(from_path, path, write_options)
          result = s3_bucket_object(from_path).write(path, write_options)
          write_to_loggers(result.inspect)
          File.join(bucket_url.to_s, to_path(from_path).to_s)
        end

        def s3_bucket_name_manager
          @s3_bucket_name_manager ||= S3BucketNameManager.new(location)
        end

        def location
          Location.where(name: @location_name).first
        end

        def write_to_loggers(msg)
          LOGGERS.each{|logger| logger.debug(msg)}
        end

        def write_compile_path_to_loggers(from_path, path, write_options)
          write_to_loggers("writing to bucket")
          write_to_loggers("#{from_path.to_s}")
          write_to_loggers("#{path.to_s}")
          write_to_loggers("#{write_options.to_s}")
        end
      end
    end
  end
end
