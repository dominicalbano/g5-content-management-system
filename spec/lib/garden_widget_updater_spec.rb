require "spec_helper"

describe GardenWidgetUpdater do
  let(:updater) { GardenWidgetUpdater.new }
  let(:gardener) { GardenWidget }

  describe "#update_all" do
    describe "when a new widget is added to the garden" do
      it "creates new GardenWidget" do
        gardener.stub(:garden_url) { "spec/support/garden_widget_updater/new.html" }
        expect { updater.update_all }.to change { gardener.count }.by(1)
      end
    end

    describe "when a widget is updated in the garden" do
      let(:garden_widget) { Fabricate(:garden_widget, url: "http://widget-garden.com/widget-test") }

      it "updates GardenWidget with same URL" do
        gardener.stub(:garden_url) { "spec/support/garden_widget_updater/updated.html" }
        expect { updater.update_all }.to change { garden_widget.reload.name }.to("Updated Garden Widget")
      end
    end

    describe "when a widget is removed from the garden" do
      let!(:garden_widget) { Fabricate(:garden_widget, url: "http://widget-garden.com/widget-test") }

      it "destroys GardenWidget with same URL" do
        gardener.stub(:garden_url) { "spec/support/garden_widget_updater/removed.html" }
        expect { updater.update_all }.to change { gardener.count }.by(-1)
      end
    end
  end

  describe "#update" do
    let(:garden_widget) { Fabricate(:garden_widget, url: "spec/support/garden_widget_updater/widget-test/updated.html") }

    before do
      updater.update(garden_widget)
    end

    it "sets url" do
      expect(garden_widget.url).to eq "http://widget-garden.com/widget-test"
    end

    it "sets name" do
      expect(garden_widget.name).to eq "Updated Garden Widget"
    end

    it "sets thumbnail" do
      expect(garden_widget.thumbnail).to eq "http://widget-garden.com/widget-test/images/thumbnail.png"
    end

    it "sets edit_html" do
      expect(garden_widget.edit_html).to eq "<div>edit.html</div>\n"
    end

    it "sets edit_javascript" do
      expect(garden_widget.edit_javascript).to eq "http://widget-garden.com/widget-test/javascripts/widget-test.js"
    end

    it "sets show_html" do
      expect(garden_widget.show_html).to eq "<div>show.html</div>\n"
    end

    it "sets show_javascript" do
      expect(garden_widget.show_javascript).to eq "http://widget-garden.com/widget-test/javascripts/widget-test.js"
    end

    it "sets lib_javascripts" do
      expect(garden_widget.lib_javascripts).to eq ["http://widget-garden.com/widget-test/javascripts/widget-test.js"]
    end

    it "sets show_stylesheets" do
      expect(garden_widget.show_stylesheets).to eq ["http://widget-garden.com/widget-test/stylesheets/widget-test.css"]
    end

    it "sets settings" do
      expect(garden_widget.settings).to eq []
    end
  end
end