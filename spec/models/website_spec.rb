require "spec_helper"

describe Website, vcr: VCR_OPTIONS do
  describe ".urn_prefix" do
    it "is g5-clw" do
      Website.urn_prefix.should eq "g5-clw"
    end
  end

  describe "validations" do
    it "should have a valid fabricator" do
      Fabricate.build(:website).should be_valid
    end

    it "should not require urn on new records" do
      Fabricate.build(:website, urn: "").should be_valid
    end

    it "should require urn on old records" do
      website = Fabricate(:website)
      website.urn = ""
      website.should_not be_valid
    end
  end

  describe "#location_websites" do
    let(:client) { Fabricate(:client) }
    let(:location) { Fabricate(:location) }
    let!(:client_website) { Fabricate(:website, owner: client) }
    let!(:location_website) { Fabricate(:website, owner: location) }

    it "returns location websites only" do
      expect(Website.location_websites).to eq([location_website])
    end
  end

  describe "#urn" do
    let(:website) { Fabricate(:website) }

    it "sets on create" do
      website.urn.should match /g5-clw-(\d|\w){7,8}-/
    end
  end

  describe "#website_id" do
    let(:website) { Fabricate(:website) }

    it "returns own id" do
      website.website_id.should eq website.id
    end
  end

  describe "#name" do
    let(:website) { Fabricate.build(:website) }
    let(:location) { Fabricate.build(:location) }

    it "uses location's name" do
      website.owner = location
      website.name.should eq location.name
    end
  end

  describe "#slug" do
    let(:website) { Fabricate.build(:website) }
    let(:location) { Fabricate.build(:location) }

    it "uses location's name parameterized" do
      website.owner = location
      website.slug.should eq location.name.parameterize
    end
  end

  describe "#compile_path" do
    let!(:client) { Fabricate(:client) }
    let!(:location) { Fabricate(:location) }
    let(:website) { Fabricate(:website, owner: location) }

    it "includes urn" do
      website.compile_path.should include website.urn
    end

    context "single domain" do
      let(:client) { Fabricate(:client, type: "SingleDomainClient") }

      subject { website.compile_path }

      before do
        Client.stub(first: client)
        client.stub(website: website)
      end

      it { should eq("#{Website::COMPILE_PATH}/#{client.website.urn}/" \
                     "#{website.single_domain_location_path}") }

      context "corporate website" do
        let!(:location) { Fabricate(:location, corporate: true) }

        it { should eq("#{Website::COMPILE_PATH}/#{client.website.urn}") }
      end
    end
  end

  describe "#stylesheets" do
    let(:website) { Fabricate(:website) }

    it "has a collection of stylesheets" do
      website.stylesheets.should be_kind_of(Array)
    end
  end

  describe "#javascripts" do
    let(:website) { Fabricate(:website) }

    it "has a collection of javascripts" do
      website.javascripts.should be_kind_of(Array)
    end
  end

  describe "#deploy" do
    let(:website) { Fabricate(:website) }

    it "calls StaticWebsiteDeployerJob with urn" do
      StaticWebsiteDeployerJob.should_receive(:perform).with(website.urn).once
      website.deploy("user@email.com")
    end
  end

  describe "#async_deploy" do
    let(:website) { Fabricate(:website) }

    it "enqueues StaticWebsiteDeployerJob with urn" do
      Resque.stub(:enqueue)
      Resque.should_receive(:enqueue).with(StaticWebsiteDeployerJob, website.urn, "user@email.com").once
      website.async_deploy
    end
  end

  describe "#colors" do
    let(:website) { Fabricate.build(:website) }
    let (:website_template) { Fabricate.build(:website_template) }

    before do
      website.website_template = website_template
      website_template.stub(:colors) { "colors!" }
    end

    it "asks website_template for colors" do
      website_template.should_receive(:colors).exactly(2).times
      expect(website.colors).to eq(website_template.colors)
    end
  end
end
