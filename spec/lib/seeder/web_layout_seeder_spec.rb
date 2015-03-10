require "spec_helper"

describe Seeder::WebLayoutSeeder do
  let!(:client) { Fabricate(:client) }
  let!(:location) { Fabricate(:location) }
  let(:website) { Fabricate(:website, owner: location) }
  let(:website_template) { Fabricate(:website_template, )}
  let(:defaults) { HashWithIndifferentAccess.new(YAML.load_file("#{Rails.root}/config/defaults/websites/defaults.yml")) }
  let(:instructions) { defaults[:website_template] }
  let(:seeder) { Seeder::WebsiteTemplateSeeder.new(website, instructions) }

  before do
    WebTemplate.any_instance.stub(:update_navigation_settings)
  end  

  describe "#seed" do
    
  end
end