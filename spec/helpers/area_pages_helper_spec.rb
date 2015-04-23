require "spec_helper"

describe AreaPagesHelper, vcr: VCR_OPTIONS do
  let!(:client) { Fabricate(:client) }
  let(:website) { Fabricate(:website) }
  let(:website_template) { Fabricate(:website_template) }
  let(:web_layout) { Fabricate(:web_layout) }
  let(:web_theme) { Fabricate(:web_theme) }
  let(:web_home_template) { Fabricate(:web_home_template) }
  let(:drop_target) { Fabricate(:drop_target, html_id: "drop-target-aside") }
  let(:widget) { Fabricate(:widget) }
  let(:renderer) { double(render: "Foo") }

  before :each do
    web_home_template.stub(:update_navigation_settings)
    AreaPageRenderer.stub(new: renderer)
    website.website_template = website_template
    website_template.web_layout = web_layout
    website_template.web_theme = web_theme
    website.web_home_template = web_home_template
    web_home_template.drop_targets << drop_target
    drop_target.widgets << widget
  end

  describe "#area_preview" do
    let(:locations) { [Fabricate(:location)] }
    let(:area) { "Bend, Oregon" }
    let(:preview) { helper.area_preview(web_home_template, locations, area) }

    it "has layout in html" do
      preview.should match /layout/
    end

    it "has widget in html" do
      preview.should match /#{widget.name.parameterize}/
    end
  end

  describe "#canonical_link_element" do
    let(:params) { { state: "oregon", city: "bend", neighborhood: "foo" } }
    let(:link) { helper.canonical_link_element(params, web_home_template) }

    it "builds the correct canonical link" do
      expect(link).to include("/oregon/bend/foo")
    end
  end
end

