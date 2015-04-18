require "aws-sdk"

module StaticWebsite
  module Compiler
    class Stylesheet
      class Uploader < StaticWebsite::Compiler::Uploader
        attr_reader :from_paths, :s3, :bucket_name, :bucket_url

        def initialize(from_path, location_name)
          write_to_loggers("Initializing StaticWebsite::Compiler::Stylesheet::Uploader with from_path: \n#{from_path}\n, location_name: #{location_name}")
          super([from_path], location_name)
        end

        def uploaded_path
          File.join(bucket_url.to_s, to_path(from_paths.first).to_s)
        end

        def data_type
          "css"
        end

        def data_dir
          "stylesheets"
        end
      end
    end
  end
end
