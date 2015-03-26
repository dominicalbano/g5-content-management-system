require "spec_helper"

describe StaticWebsite::Compiler::Javascript::Uploader do
  let!(:location) { Fabricate(:location, name: "North Shore Oahu", urn: "g5-cl-north-shore") }
  let!(:location2) { Fabricate(:location, name: "North Shore O'ahu", urn: "g5-cl-north-shore-2") }
  let(:uploader_class) { StaticWebsite::Compiler::Javascript::Uploader }
  let(:uploader) { uploader_class.new(['javascripts/one.js', 'javascripts/two.js'], "location foo") }

  describe "#compile" do
    before do
      @bucket_object = double(:bucket_object)
      aws_bucket = double(:aws_bucket, exists?: true, objects: 
                          {"foo/javascripts/one.js" => @bucket_object, 
                           "foo/javascripts/two.js" => @bucket_object})

      s3_instance = double(:s3_instance, buckets: {"foo" => aws_bucket})
      location = Fabricate(:location)
      @pathname_instance = double(:pathname_instance, realpath: "foo")


      allow(Pathname).to receive(:new).and_return(@pathname_instance)
      allow(location).to receive(:bucket_asset_key_prefix).and_return("foo")

      allow(AWS::S3).to receive(:new).and_return(s3_instance)
      allow(S3BucketNameManager).to receive(:new).and_return(
        double(:bnm, {bucket_name: "foo", 
                      bucket_url: "foo.com/path"}))
      allow(Location).to receive_message_chain(:where, :first) {location}
      write_options = {:acl => :public_read, :content_type => "text/javascript",
                                            metadata: {"x-amz-meta-freshness" => "current"}}
      allow(@bucket_object).to receive("write").with(@pathname_instance, write_options).and_return("you wrote")
    end

    it "sets the @uploaded_paths accessor after compile" do
      expect(uploader.tap {|uploader| uploader.upload}.uploaded_paths).to eq(
        ["foo.com/path/foo/javascripts/one.js", "foo.com/path/foo/javascripts/two.js"]
      )
    end

    it "builds the uploaded_paths array" do
      expect(uploader.upload).to eq ["foo.com/path/foo/javascripts/one.js", "foo.com/path/foo/javascripts/two.js"]
    end

    it "writes the files in the from_path to the s3 bucket once for each from_path" do
      write_options = {:acl => :public_read, :content_type => "text/javascript",
                                            metadata: {"x-amz-meta-freshness" => "current"}}

      expect(@bucket_object).to receive("write").with(@pathname_instance, write_options).and_return("you wrote")
      uploader.upload
    end
  end
end

