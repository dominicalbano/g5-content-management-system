require "spec_helper"

describe WebTemplatesHelper, vcr: VCR_OPTIONS do
  let(:website) { Fabricate(:website) }
  let(:website_template) { Fabricate(:website_template) }
  let(:web_layout) { Fabricate(:web_layout) }
  let(:web_theme) { Fabricate(:web_theme) }
  let(:web_home_template) { Fabricate(:web_home_template) }
  let(:drop_target) { Fabricate(:drop_target, html_id: "drop-target-main") }
  let(:widget) { Fabricate(:widget) }

  before :each do
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
end
