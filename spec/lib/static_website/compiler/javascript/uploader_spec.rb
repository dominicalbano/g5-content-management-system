require "spec_helper"

describe StaticWebsite::Compiler::Javascript::Uploader do
  let(:uploader_klass) { StaticWebsite::Compiler::Javascript::Uploader }

  describe "#bucket_name" do
    it "accesses the ENV variable for the location" do
      ENV["AWS_S3_BUCKET_NAME_NORTH_SHORE_OAHU"] = "assets.northshoreoahu.com"
      uploader = uploader_klass.new([], "North Shore Oahu")
      expect(uploader.bucket_name).to eq "assets.northshoreoahu.com"
    end
    it "handles non letter characters" do
      ENV["AWS_S3_BUCKET_NAME_NORTH_SHORE_O_AHU"] = "assets.northshoreoahu.com"
      uploader = uploader_klass.new([], "North Shore O'ahu")
      expect(uploader.bucket_name).to eq "assets.northshoreoahu.com"
    end
  end

  describe "#bucket_url" do
    it "accesses the ENV variable for the location" do
      ENV["AWS_S3_BUCKET_URL_NORTH_SHORE_OAHU"] = "http://assets.northshoreoahu.com"
      uploader = uploader_klass.new([], "North Shore Oahu")
      expect(uploader.bucket_url).to eq "http://assets.northshoreoahu.com"
    end
  end

  describe "#write_options" do
    let(:uploader) { uploader_klass.new([], "") }

    it "is public readable" do
      expect(uploader.write_options[:acl]).to eq :public_read
    end

    it "content type is 'text/javascript'" do
      expect(uploader.write_options[:content_type]).to eq "text/javascript"
    end
  end
end
