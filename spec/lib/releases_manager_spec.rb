require 'spec_helper'

describe ReleasesManager do
  let!(:location) { Fabricate(:location) }
  let!(:website) { Fabricate(:website, owner: location) }
  let(:releases_manager) { ReleasesManager.new(website_slug, limit) }
  let(:limit) { nil }

  describe "#fetch_all" do
    subject { releases_manager.fetch_all }

    context "a valid location" do
      let(:releases) { open(Rails.root+"spec/fixtures/releases.json").read }
      let(:website_slug) { location.name.parameterize }

      before { HTTParty.stub_chain(:get, :body).and_return(releases) }

      its(:size) { 5 }

      context "custom limit" do
        let(:limit) { 3 }

        its(:size) { 3 }
      end

      context "specific data with no rollbacks" do
        subject { releases_manager.fetch_all.first }

        its(["id"]) { should eq("c83d6988-36b8-42b0-a30a-c0df1d0797f6") }
        its(["version"]) { should eq(48) }
        its(["created_at"]) { should eq("2014-01-22T00:16:59Z") }
        its(["description"]) { should eq("Deploy aeccd5a") }
        its(["current"]) { should be_truthy }
      end

      context "specific data with a rollback" do
        let(:releases) do
          open(Rails.root+"spec/fixtures/releases_rolledback.json").read
        end

        subject { releases_manager.fetch_all.first }

        its(["id"]) { should eq("e26ae957-c33e-41ef-b9a5-31fc40fda36b") }
        its(["version"]) { should eq(53) }
        its(["created_at"]) { should eq("2014-01-22T00:20:00Z") }
        its(["description"]) { should eq("Deploy 1h12h") }
        its(["current"]) { should be_truthy }
      end

      context "bad credentials" do
        let(:releases) do
          '{"id":"unauthorized","message":"Invalid credentials provided."}'
        end

        it { should be_empty }
      end
    end

    context "an in-valid location" do
      let(:website_slug) { nil }

      it { should be_nil }
    end
  end

  describe "#rollback" do
    let(:release_id) { "12-3" }

    subject { releases_manager.rollback(release_id) }

    context "a valid location" do
      let(:website_slug) { location.name.parameterize }
      let(:heroku_client) { double(rollback: nil) }

      before { HerokuClient.stub(new: heroku_client) }

      it "calls rollback on HerokuClient" do
        heroku_client.should_receive(:rollback)
        subject
      end
    end

    context "an in-valid location" do
      let(:website_slug) { nil }

      it { should be_nil }
    end
  end
end
