require "spec_helper"

describe StaticWebsite::Compiler::Stylesheet::Uploader do
  let(:uploader_klass) { StaticWebsite::Compiler::Stylesheet::Uploader }

  describe "#bucket_name" do
    it "accesses the ENV variable for the location" do
      ENV["AWS_S3_BUCKET_NAME_NORTH_SHORE_OAHU"] = "assets.northshoreoahu.com"
      uploader = uploader_klass.new([], "North Shore Oahu")
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
end
