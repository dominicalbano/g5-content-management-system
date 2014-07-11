require "spec_helper"

describe "Integration assets", auth_request: true, integration: true, js: true, vcr: VCR_OPTIONS do
  before do
    @client, @location, @website = seed
    visit "/#{@website.slug}/assets"
  end

  it "shows the file select input" do
    binding.pry
    page.should have_css "input[type=file]"
  end

  context "has assets" do
    it "shows an asset" do
      page.should have_css "li.asset"
    end
  end
end
