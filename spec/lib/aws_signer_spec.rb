require 'spec_helper'
require 'timecop'

describe AWSSigner do
  let!(:location) { Fabricate(:location, name: "foobarlocation", urn: "foo") }
  let!(:client) {Fabricate(:client, uid: "client-urn")}

  subject do
    AWSSigner.new({:locationName => 'foobarlocation',
                   :name => 'file with spaces.something.jpg'})
  end

  before do
    Timecop.freeze(DateTime.new(1983,8,17))
  end

  after do
    Timecop.return
  end

  describe "#upload_headers" do
    it "returns a hash of header items" do
      subject.upload_headers.should include :acl => "public-read"
      subject.upload_headers.should include \
        :signature => "EyOpsiDQ55Fo9aeENPyXgUhg4OM="
      subject.upload_headers.should include :key => "uploads/file-with-spaces.something.jpg"
    end
  end

  describe "#delete_headers" do
    it "returns a hash of header items" do
      subject.delete_headers.should include :aws_access_key_id => ENV['AWS_ACCESS_KEY_ID']
      subject.delete_headers.should include \
        :signature =>"e737aa61a2f92f9d0116db5fd4f746994e386e73a8eae7dd8833aed6eb83583a"
    end
  end
end
