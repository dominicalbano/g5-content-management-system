require "spec_helper"

describe Seeder::WebsiteSeeder do
  let!(:client) { Fabricate(:client) }
  let!(:location) { Fabricate(:location) }
  let(:website) { Fabricate(:website, owner: location) }
  let(:defaults) { load_website_yaml_file("defaults") }
  let(:seeder) { Seeder::WebsiteSeeder.new(location) }

  before do
    WebTemplate.any_instance.stub(:update_navigation_settings)
  end  

  def setting_value_for(name)
    setting = website.settings.detect { |w| w.name == name }
    setting.value unless setting.blank?
  end

  describe "#seed" do
    let(:client_services) { ClientServices.new }

    before { location.stub(create_website: website) }
    subject { seeder.seed }

    it "returns a website" do
      expect(subject).to eq(website)
    end

    it "creates settings for the website" do
      subject
      expect(setting_value_for("client_url")).to eq(client_services.client_url)
      expect(setting_value_for("client_location_urns")).to eq(client_services.client_location_urns)
      expect(setting_value_for("client_location_urls")).to eq(client_services.client_location_urls)
      expect(setting_value_for("location_urn")).to eq(location.urn)
      expect(setting_value_for("location_url")).to eq(location.domain)
      expect(setting_value_for("location_street_address")).to eq(location.street_address)
      expect(setting_value_for("location_city")).to eq(location.city)
      expect(setting_value_for("location_state")).to eq(location.state)
      expect(setting_value_for("location_postal_code")).to eq(location.postal_code)
      expect(setting_value_for("phone_number")).to eq(location.phone_number)
      expect(setting_value_for("row_widget_garden_widgets")).to eq(ContentStripeWidgetGardenWidgetsSetting.new.value)
      expect(setting_value_for("locations_navigation")).to eq(LocationsNavigationSetting.new.value)
      expect(setting_value_for("corporate_map")).to eq(CorporateMapSetting.new.value)
    end

    it "creates the appropriate templates" do
      seeder.should_receive(:create_website_template)
      seeder.should_receive(:create_web_home_template)
      seeder.should_receive(:create_web_page_templates)
      subject
    end
  end

  describe "#create_website_template" do
    let(:instructions) { defaults["website_template"] }
    let!(:website_template) { Fabricate(:website_template) }

    subject { seeder.create_website_template(website, instructions) }

    context "a valid website" do
      before { website.stub(create_website_template: website_template) }
      after  { subject }

      it "creates a website template for the website" do
        website.should_receive(:create_website_template)
      end

      it "creates a web layout for the template" do
        website_template.should_receive(:create_web_layout)
      end

      it "creates a web theme for the template" do
        website_template.should_receive(:create_web_theme)
      end
    end

    context "no website" do
      let(:website) { nil }

      it { should be_nil }
    end
  end

  describe "#create_web_home_template" do
    let(:instructions) { defaults["web_home_template"] }
    let!(:web_home_template) { Fabricate(:web_home_template) }

    before do
      web_home_template.stub(:update_navigation_settings)
    end  

    subject { seeder.create_web_home_template(website, instructions) }

    context "a valid website" do
      before { website.stub(create_web_home_template: web_home_template) }
      after  { subject }

      it "creates a web home template for the website" do
        website.should_receive(:create_web_home_template)
      end
    end

    context "no website" do
      let(:website) { nil }

      it { should be_nil }
    end
  end

  describe "#create_web_page_templates" do
    let(:instructions) { [defaults["web_page_templates"].first] }
    let!(:web_page_template) { Fabricate(:web_page_template) }

    before do
      web_page_template.stub(:update_navigation_settings)
    end  

    subject { seeder.create_web_page_templates(website, instructions) }

    context "a valid website" do
      before { website.web_page_templates.stub(create: web_page_template) }
      after  { subject }

      it "creates a web page template for each instruction" do
        website.web_page_templates.should_receive(:create)
      end
    end

    context "no website" do
      let(:website) { nil }

      it { should be_nil }
    end
  end
end
