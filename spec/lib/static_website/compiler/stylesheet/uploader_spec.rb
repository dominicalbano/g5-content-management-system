require "spec_helper"

describe StaticWebsite::Compiler::Stylesheet::Uploader do
  let!(:location) { Fabricate(:location, name: "North Shore Oahu", urn: "g5-cl-north-shore") }
  let!(:location2) { Fabricate(:location, name: "North Shore O'ahu", urn: "g5-cl-north-shore-2") }
  let(:uploader_klass) { StaticWebsite::Compiler::Stylesheet::Uploader }

  describe "#bucket_name" do
    it "accesses the ENV variable for the location" do
      ENV["AWS_S3_BUCKET_NAME_G5_CL_NORTH_SHORE"] = "assets.northshoreoahu.com"
      uploader = uploader_klass.new([], "North Shore Oahu")
      expect(uploader.bucket_name).to eq "g5-orion-clients"
    end
    it "handles non alphanumeric chars" do
      ENV["AWS_S3_BUCKET_NAME_G5_CL_NORTH_SHORE_2"] = "assets.northshoreoahu.com"
      uploader = uploader_klass.new([], "North Shore O'ahu")
      expect(uploader.bucket_name).to eq "g5-orion-clients"
    end
  end

  describe "#bucket_url" do
    it "accesses the ENV variable for the location" do
      ENV["AWS_S3_BUCKET_URL_G5_CL_NORTH_SHORE"] = "http://assets.northshoreoahu.com"
      uploader = uploader_klass.new([], "North Shore Oahu")
      expect(uploader.bucket_url).to eq "https://s3-us-west-2.amazonaws.com/g5-orion-clients"
    end
  end

  describe "#write_options" do
    let(:uploader) { uploader_klass.new([], "") }

    it "is public readable" do
      expect(uploader.write_options[:acl]).to eq :public_read
    end

    it "content type is 'text/css'" do
      expect(uploader.write_options[:content_type]).to eq "text/css"
    end
  end
end
