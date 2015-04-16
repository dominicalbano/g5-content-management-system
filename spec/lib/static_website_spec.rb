#
# CAUTION!!!
#
# This spec actually attempts to deploy a client location
# site. It must make outside HTTP requests to do this.  It
# does not run by default. To run this spec run:
#
# rspec spec -t deployment
#
# You will need the deployment enviroment varibales to be set.
#

require "spec_helper"

describe StaticWebsite, vcr: { record: :new_episodes }, deployment: true do
  before do
    @client = Fabricate(:client)
    @location = Fabricate(:location)
    Seeder::WebsiteSeeder.new(@location).seed
  end

  it "compiles and deploys website" do
    StaticWebsite.compile_and_deploy(@location.website.decorate)
  end
end
