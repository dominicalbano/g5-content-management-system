require 'spec_helper'

describe SavesManager do
  let(:saves_manager) { SavesManager.new("user@email.com") }
  let(:saves) { JSON.parse(open(Rails.root+"spec/fixtures/saves.json").read) }

  before do
    SavesManager.any_instance.stub(:fetch_all).and_return(saves)
  end

  describe "#fetch_all" do
    subject { saves_manager.fetch_all }

    context "db backups existing in bucket" do
      before do
        AWS.stub_chain(:s3, :buckets).and_return(saves)
      end

      subject { saves_manager.fetch_all.first }

      its(["id"]) { should eq("user@foo.com-a257b175-587a-4c75-82e7-d3d2903b3464-DATABASE-URL.dump") }
      its(["created_at"]) { should eq("2014-01-21T19:30:19Z") }
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

