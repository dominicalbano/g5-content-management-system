require 'spec_helper'
require 'timecop'

describe AWSSigner do
  let!(:location) { Fabricate(:location, name: "foobarlocation", urn: "foo") }

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
        :signature => "nt/NKEd10o/Nah9Vftgw2yspuuk="
      subject.upload_headers.should include :key => "uploads/file-with-spaces.something.jpg"
    end
  end

  describe "#delete_headers" do
    it "returns a hash of header items" do
      subject.delete_headers.should include :aws_access_key_id => ENV['AWS_ACCESS_KEY_ID']
      subject.delete_headers.should include \
        :signature => "2aaa9a913e4a5a359c26044ad53bec03964ae735465247f2018568485017a72d"
    end
  end
end
