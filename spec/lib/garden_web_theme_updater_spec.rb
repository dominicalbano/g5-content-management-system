require "spec_helper"

describe GardenWebThemeUpdater do
  let(:updater) { GardenWebThemeUpdater.new }
  let(:gardener) { GardenWebTheme }

  describe "#update_all" do
    describe "when a new theme is added to the garden" do
      it "creates new GardenWebTheme" do
        gardener.stub(:garden_url) { "spec/support/garden_web_theme_updater/new.html" }
        expect { updater.update_all }.to change { gardener.count }.by(1)
      end
    end

    describe "when a theme is updated in the garden" do
      let(:garden_web_theme) do
        Fabricate(:garden_web_theme, name: "Updated Garden Theme",
                                     url: "http://theme-garden.com/foo")
      end

      it "updates GardenWebTheme with same name" do
        gardener.stub(:garden_url) { "spec/support/garden_web_theme_updater/updated.html" }
        expect { updater.update_all }.to change { garden_web_theme.reload.url }.to("http://theme-garden.com/theme-test")
      end
    end

    describe "when a theme is removed from the garden" do
      let!(:garden_web_theme) { Fabricate(:garden_web_theme, url: "http://theme-garden.com/theme-test") }

      it "destroys GardenWebTheme with same URL if not in use" do
        gardener.stub(:garden_url) { "spec/support/garden_web_theme_updater/removed.html" }
        expect { updater.update_all }.to change { gardener.count }.by(-1)
      end

      it "does not destroy GardenWebTheme with same URL if it is in use" do
        Fabricate(:web_theme, garden_web_theme: garden_web_theme)
        gardener.stub(:garden_url) { "spec/support/garden_web_theme_updater/removed.html" }
        expect { updater.update_all }.not_to change { gardener.count }
      end
    end
  end

  describe "#update" do
    let(:garden_web_theme) { Fabricate(:garden_web_theme, url: "spec/support/garden_web_theme_updater/theme-test/updated.html") }

    before do
      updater.update(garden_web_theme)
    end

    it "sets url" do
      expect(garden_web_theme.url).to eq "http://theme-garden.com/theme-test"
    end

    it "sets name" do
      expect(garden_web_theme.name).to eq "Updated Garden Theme"
    end

    it "sets thumbnail" do
      expect(garden_web_theme.thumbnail).to eq "http://theme-garden.com/theme-test/images/thumbnail.png"
    end

    it "sets stylesheets" do
      expect(garden_web_theme.stylesheets).to eq ["http://theme-garden.com/theme-test/stylesheets/theme-test.css"]
    end

    it "sets javascripts" do
      expect(garden_web_theme.javascripts).to eq ["http://theme-garden.com/theme-test/javascripts/theme-test.js"]
    end

    it "sets primary_color" do
      expect(garden_web_theme.primary_color).to eq "#primary"
    end

    it "sets secondary_color" do
      expect(garden_web_theme.secondary_color).to eq "#secondary"
    end

  end
end
