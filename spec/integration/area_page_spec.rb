require "spec_helper"

describe "Integration '/areas'", auth_request: true, integration: true, vcr: VCR_OPTIONS do
  let!(:client) { Fabricate(:client) }
  let!(:corporate_location) { Fabricate(:location, corporate: true) }
  let!(:website) { Fabricate(:website, owner: corporate_location) }
  let!(:website_template) { Fabricate(:website_template, website: website) }
  let!(:web_layout) { Fabricate(:web_layout, web_template: website_template)}
  let!(:drop_target) { Fabricate(:head_drop_target, web_template: website_template)}
  let!(:widget) { Fabricate(:widget, drop_target: drop_target) }

  describe "Lists all locations for the given route" do
    let!(:state_location) { Fabricate(:location, state: "OR", status: "Live") }
    let!(:state_website) { Fabricate(:website, owner: state_location) }
    let!(:city_location) { Fabricate(:location, state: "OR", city: "Bend", status: "Live") }
    let!(:city_website) { Fabricate(:website, owner: city_location) }
    let!(:neighborhood_location) do
      Fabricate(:location, state: "OR", city: "Bend", neighborhood: "Foo", status: "Live")
    end
    let!(:neighborhood_website) { Fabricate(:website, owner: neighborhood_location) }

    context "state, city and neighborhood parameters" do
      before { visit "/areas/or/bend/foo" }

      it "has the appropriate area in the header" do
        expect(page).to have_content("Locations in Foo, Bend, OR")
      end

      it "has one location" do
        expect(page.all(".area-page .adr").count).to eq(1)
      end

      it "displays the location's url" do
        expect(page).to have_link("Visit Location"),
                        href: neighborhood_website.decorate.url
      end

      it "displays the location's street address" do
        expect(page).to have_content(neighborhood_location.street_address)
      end

      it "displays the location's city" do
        expect(page).to have_content(neighborhood_location.city)
      end

      it "displays the location's state" do
        expect(page).to have_content(neighborhood_location.state)
      end

      it "displays the location's postal_code" do
        expect(page).to have_content(neighborhood_location.postal_code)
      end
    end

    context "state, and city parameters" do
      before {visit "/areas/or/bend" }

      it "has the appropriate area in the header" do
        expect(page).to have_content("Locations in Bend, OR")
      end

      it "has two locations" do
        expect(page.all(".area-page .adr").count).to eq(2)
      end
    end

    context "state only parameters" do
      before {visit "/areas/or"}

      it "has the appropriate area in the header" do
        expect(page).to have_content("Locations in OR")
      end

      it "has 3 locations" do
        expect(page.all(".area-page .adr").count).to eq(3)
      end
    end
  end
end
