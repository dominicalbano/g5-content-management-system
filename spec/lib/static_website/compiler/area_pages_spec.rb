require "spec_helper"

describe StaticWebsite::Compiler::AreaPages do
  let(:area_pages) { described_class.new(base_path, websites) }
  let(:location_one) { Fabricate(:location, city: "Bend", state: "Oregon", neighborhood: "foo") }
  let(:location_two) { Fabricate(:location, city: "Boise", state: "Idaho", neighborhood: "bar") }
  let(:website_one) { Fabricate(:website, owner: location_one) }
  let(:website_two) { Fabricate(:website, owner: location_two) }

  describe "#compile" do
    let(:websites) { [website_one, website_two] }
    let(:base_path) { "foo" }
    let(:area_page) { double(compile: "foo/bar/index.html") }
    let!(:client) { Fabricate(:client) }

    subject { area_pages.compile }

    before { StaticWebsite::Compiler::AreaPage.stub(new: area_page) }

    it "compiles area pages for each state and city do" do
      area_page.should_receive(:compile).exactly(6).times
      subject
    end
  end
end

