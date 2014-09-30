require 'spec_helper'

describe SavesManager do
  let(:saves_manager) { SavesManager.new("user@email.com") }
  let(:saves) { open(Rails.root+"spec/fixtures/saves.json").read }

  describe "#fetch_all" do
    subject { saves_manager.fetch_all }

    context "db backups existing in bucket" do
      before do
        AWS.stub_chain(:s3, :buckets).and_return(saves)
      end

      subject { saves_manager.fetch_all.first }

      its(["id"]) { should eq("c83d6988-36b8-42b0-a30a-c0df1d0797f6") }
      its(["created_at"]) { should eq("2014-01-22T00:16:59Z") }
    end

    context "bad credentials" do
      let(:saves) do
        '{"id":"unauthorized","message":"Invalid credentials provided."}'
      end

      it { should be_empty }
    end
  end

  describe "#restore" do
    let(:save_id) { "12-3" }
    let!(:client) {Fabricate(:client)}

    subject do
      saves_manager.restore(save_id)
    end

    context "a valid location" do
      let(:website_slug) { location.name.parameterize }
      let(:heroku_client) { double(restore: nil) }

      before { HerokuClient.stub(new: heroku_client) }

      it "calls restore on HerokuClient" do
        expect(GithubHerokuDeployer).to receive(:heroku_run).with("foo")
        subject
      end
    end

    context "an in-valid location" do
      let(:website_slug) { nil }

      it { should be_nil }
    end
  end
end

