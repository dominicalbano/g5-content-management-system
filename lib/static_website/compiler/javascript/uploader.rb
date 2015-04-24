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

        def data_type
          "javascript"
        end

        def data_dir
          "javascripts"
        end
      end
    end
  end
end
