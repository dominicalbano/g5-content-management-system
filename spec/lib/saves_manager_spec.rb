require 'spec_helper'

describe SavesManager do
  let(:saves_manager) { SavesManager.new("user@email.com") }
  let(:saves) {[
    double({created_at:"2014-01-21T19:30:19Z",
            key:"user@foo.com-9547b11a-2236-4cfb-b6ad-11cdca45c1cf-DATABASE-URL.dump",
            last_modified: "2014-01-21T19:34:25Z"}),
    double({created_at:"2014-01-21T19:34:25Z",
            key:"user2@foo.com-9547b11a-2236-4cfb-b6ad-11cdcafoo-DATABASE-URL.dump",
            last_modified: "2014-01-21T19:34:25Z"})
  ]}
  let!(:client){Fabricate(:client)}

  before do
    saves.stub_chain(:as_tree, :children).and_return(saves)
    AWS.stub_chain(:s3, :buckets, :[]).and_return(saves)
  end

  describe "#fetch_all" do
    subject { saves_manager.fetch_all }

    context "db backups existing in bucket" do
      subject { saves_manager.fetch_all.first }

      its([:id]) {should eq("user@foo.com-9547b11a-2236-4cfb-b6ad-11cdca45c1cf-DATABASE-URL") }
      its([:created_at]) { should eq("2014-01-21T19:34:25Z") }
    end
  end

  describe "#restore" do
    before do
      expect(GithubHerokuDeployer).to receive(:heroku_run).with("foo")
      AWS.stub_chain(:s3, :buckets).and_return(saves)
    end

    let(:save_id) { "12-3" }
    let!(:client) {Fabricate(:client)}

    subject do
      saves_manager.restore(save_id)
    end

  end
end

