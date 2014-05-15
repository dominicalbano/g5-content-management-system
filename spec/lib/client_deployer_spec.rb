#
# CAUTION!!!
#
# This spec actually attempts to deploy a client location
# site. It must make outside HTTP requests to do this.  It
# does not run by default. To run this spec run:
#
# rspec spec -t type:deployment
#
# You will need the deployment enviroment varibales to be set.
#

require "spec_helper"

describe ClientDeployer, vcr: { record: :new_episodes }, type: "deployment" do
  before do
    @client = Fabricate(:client)
    @location = Fabricate(:location)
    WebsiteSeeder.new(@location).seed
  end

  it "compiles and deploys website" do
    StaticWebsite.compile_and_deploy(@client)
  end
end
