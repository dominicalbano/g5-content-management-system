require "spec_helper"

describe "Integration '/'", auth_request: true, integration: true, js: true, vcr: VCR_OPTIONS do
  describe "Lists all locations" do
    before do
      Resque.stub(:enqueue)

      @client = Fabricate(:client, uid: "http://g5-hub.herokuapp.com/clients/g5-c-123abc-blah-blah-blah")
      @location = Fabricate(:location)
      @website = Fabricate(:website, owner: @location)
      @location.reload

      visit root_path
    end

    it "Client and location names are displayed" do
      # CSS upcases this name, so we also upcase
      expect(page).to have_content(@client.name)
      expect(page).to have_content(@location.name)
    end

    it "'Deploy' link redirects back to root path" do
      accept_confirm do
        within LOCATION_SELECTOR do
          click_link "Deploy"
        end
      end
      expect(current_path).to eq(root_path)
    end

    it "'Edit' link goes to Ember App" do
      within LOCATION_SELECTOR do
        click_link "Edit"
      end

      within ".breadcrumb" do
        expect(page).to have_content(@client.name)
        expect(page).to have_content(@location.name)
      end

      expect(current_path).to eq("/#{@website.slug}")
    end

    it "'View' link goes to Heroku App" do
      # Wait for href to be populated
      sleep 1

      within LOCATION_SELECTOR do
        click_link "View"
      end

      expect(page).to have_content("Heroku | No such app")
    end

    it "Update widgets link produces a flash notice" do
      click_link "Update Widgets"
      expect(page).to have_selector(".alert-box", "UPDATING WIDGETS")
    end

    it "Update themes link produces a flash notice" do
      click_link "Update Themes"
      expect(page).to have_selector(".alert-box", "UPDATING THEMES")
    end

    it "Update layouts link produces a flash notice" do
      click_link "Update Layouts"
      expect(page).to have_selector(".alert-box", "UPDATING LAYOUTS")
    end
  end
end
