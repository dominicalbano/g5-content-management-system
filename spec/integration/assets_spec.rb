require "spec_helper"

describe "Integration assets", auth_request: true, integration: true, js: true, vcr: VCR_OPTIONS do
  before do
    @client, @location, @website = seed
    visit "/#{@website.slug}/assets"
  end

  it "hides the file select input" do
    expect(page).to_not have_css "input[type=file]"
  end

  it "shows the file select label" do
    expect(page).to have_content "UPLOAD NEW FILES"
  end

  context "has assets" do
    it "shows an asset" do
      page.should have_css "li.asset"
    end
  end
end
