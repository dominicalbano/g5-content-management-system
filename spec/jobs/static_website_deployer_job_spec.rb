require "spec_helper"

describe StaticWebsiteDeployerJob do
  let(:website) { Fabricate(:website) }

  before do
    StaticWebsite.stub(:compile_and_deploy)
  end

  it "decorates website object" do
    Website.any_instance.should_receive(:decorate).once
    StaticWebsiteDeployerJob.perform(website.urn)
  end

  it "compile and deploys website" do
    StaticWebsite.should_receive(:compile_and_deploy).with(website.decorate).once
    StaticWebsiteDeployerJob.perform(website.urn)
  end
end
