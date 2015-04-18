require "aws-sdk"

module StaticWebsite
  module Compiler
    class Javascript
      class Uploader < StaticWebsite::Compiler::Uploader
        attr_reader :from_paths, :s3, :bucket_name, :bucket_url, :uploaded_paths

        def initialize(from_paths, location_name)
          write_to_loggers("\n\nInitializing StaticWebsite::Compiler::Javascript::Uploader with from_paths: #{Array(from_paths).join("\n\t").prepend("\n\t")},\n\tlocation_name: #{location_name}\n")
          super(from_paths, location_name)
        end

        def s3_bucket
          @s3_bucket ||= s3.buckets[bucket_name].exists? ? s3.buckets[bucket_name] : s3.buckets.create(bucket_name)
        end

        def s3_bucket_object(from_path)
          s3_bucket.objects[to_path(from_path)]
        end

        def data_type
          "javascript"
        end

        def data_dir
          "javascripts"
        end

        private

        def s3_bucket_update(from_path, path, write_options)
          path = Pathname.new(from_path)
          write_to_loggers("writing to bucket\n#{from_path.to_s}\n#{path.to_s}\n#{write_options.to_s}")
          result = s3_bucket_object(from_path).write(path, write_options)
          write_to_loggers(result.inspect)
          File.join(bucket_url.to_s, to_path(from_path).to_s)
        end
      end
    end
  end
end
