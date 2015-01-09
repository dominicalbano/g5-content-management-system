require "spec_helper"

describe WebTemplatesHelper, vcr: VCR_OPTIONS do
  let!(:client) {Fabricate(:client)}
  let(:website) { Fabricate(:website) }
  let(:website_template) { Fabricate(:website_template) }
  let(:web_layout) { Fabricate(:web_layout) }
  let(:web_theme) { Fabricate(:web_theme) }
  let(:web_home_template) { Fabricate(:web_home_template) }
  let(:drop_target) { Fabricate(:drop_target, html_id: "drop-target-main") }
  let(:widget) { Fabricate(:widget) }

  before :each do
    website_template.stub(:update_navigation_settings)
    web_home_template.stub(:update_navigation_settings)
    website.website_template = website_template
    website_template.web_layout = web_layout
    website_template.web_theme = web_theme
    website.web_home_template = web_home_template
    web_home_template.drop_targets << drop_target
    drop_target.widgets << widget
  end

  describe "preview" do
    let(:preview) { helper.preview(web_layout, web_home_template) }

    it "has layout in html" do
      preview.should match /layout/
    end
    it "has widget in html" do
      preview.should match /#{widget.name.parameterize}/
    end
  end

  describe "preview_configs" do
    let(:preview_configs) { helper.preview_configs(params, web_home_template) }

    it "defines the location URN" do
      JSON.parse(preview_configs)["urn"].should eq(params["urn"])
    end
    it "defines the website slug" do
      JSON.parse(preview_configs)["slug"].should eq(web_home_template.website.client.vertical_slug)
    end
    it "defines if we are at corporate level" do
      JSON.parse(preview_configs)["corporate"].should eq(website.corporate?)
    end
    it "defines the website slug for corp" do
      JSON.parse(preview_configs)["slug_corporate"].should eq(web_home_template.website.web_home_template.preview_url)
    end
  end
end
