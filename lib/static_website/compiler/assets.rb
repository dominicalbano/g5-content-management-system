module StaticWebsite
  module Compiler
    class Assets

      attr_reader :paths, :compile_path, :location_name, :preview, :asset_paths, :asset_urls

      def initialize(paths, compile_path, location_name="", preview=false)
        @paths = Array(paths).try(:compact).try(:uniq)
        write_to_loggers("\n\nInitializing StaticWebsite::Compiler::#{asset_class} with paths: #{@paths.join("\n\t").prepend("\n\t")},\n\n\tcompile_path: #{compile_path}") unless @paths.blank?
        @compile_path = compile_path
        @location_name = location_name
        @preview = preview
      end

      def compressor
        @compressor ||= asset_class::Compressor.new(@asset_paths, compressed_path)
      end

      def compressed_path
        @compressed_path ||= File.join(@compile_path, asset_name.pluralize, "#{asset_file_name}.min.#{asset_ext}")
      end

      def uploader
        @uploader ||= asset_class::Uploader.new(compressed_path, @location_name)
      end

      def uploaded_path
        @uploaded_path ||= uploader.uploaded_path
      end

      def uploaded_paths
        @uploaded_paths ||= uploader.uploaded_paths
      end

      def compile
        @asset_urls = []
        @asset_paths = []
        return if @paths.blank?
        compile_paths
        write_to_loggers("Starting #{asset_name} compile")
        @asset_paths = Array(compressor.compile) unless preview
        write_to_loggers("Finished #{asset_name} compile\nCalling compile on #{asset_name} uploader unless preview")
        uploader.compile unless preview
      end

      def compile_paths
        @paths.each { |path| compile_asset(path) }
      end

      def compile_asset(path)
        return if path.blank?
        asset = asset_class.new(path, @compile_path)
        if asset.try(:compile)
          @asset_paths << asset.try(asset_path)
          @asset_urls << asset.try(asset_url)
        end
      end

      protected

      def asset_name
        raise NotImplementedError
      end

      def asset_class
        raise NotImplementedError
      end

      def asset_ext
        raise NotImplementedError
      end

      def asset_file_name
        raise NotImplementedError
      end

      def asset_path
        raise NotImplementedError
      end

      def asset_url
        raise NotImplementedError
      end
    end
  end
end
