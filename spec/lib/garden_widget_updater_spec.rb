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
      let(:garden_widget) do
        Fabricate(:garden_widget, name: "Updated Garden Widget",
                                  url: "http://widget-garden.com/foo")
      end

      it "updates GardenWidget with same URL" do
        gardener.stub(:garden_url) { "spec/support/garden_widget_updater/updated.html" }
        expect { updater.update_all }.to change { garden_widget.reload.url }.to("http://widget-garden.com/widget-test")
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

    describe "GardenWidget attributes" do
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
        expect(garden_widget.settings).to eq [{:name=>"text", :editable=>"true",
          :default_value=>"Lorem ipsum.", :categories=>["Instance"]}]
      end
    end

    describe "Widget settings" do
      it "creates a new setting" do
        widget = Fabricate(:widget, garden_widget: garden_widget)
        expect { updater.update(garden_widget) }.to change { Setting.count }.by(1)
        expect(widget.reload.settings.first.name).to eq "text"
      end

      it "updates an existing setting with the same name" do
        widget = Fabricate(:widget, garden_widget: garden_widget)
        setting = Fabricate(:setting, name: "text", owner: widget)
        expect { updater.update(garden_widget) }.not_to change { Setting.count }
        expect(setting.reload.default_value).to eq "Lorem ipsum."
      end

      it "removes old settings" do
        widget = Fabricate(:widget, garden_widget: garden_widget)
        setting = Fabricate(:setting, name: "text", owner: widget)
        setting = Fabricate(:setting, name: "old", owner: widget)
        expect { updater.update(garden_widget) }.to change { Setting.count }.by(-1)
      end
    end

    describe "row_widget garden widgets setting" do
      let!(:website) { Fabricate(:website) }
      let(:value) { garden_widget.name }
      let(:row_widget_garden_widgets) do
        website.settings.where(name: "row_widget_garden_widgets")
      end

      context "with no existing setting" do
        context "before executing update" do
          it "does not have a setting" do
            expect(row_widget_garden_widgets).to be_empty
          end
        end

        context "after executing update" do
          before { updater.update(garden_widget) }

          it "creates the row_widget_garden_widgets setting" do
            expect(row_widget_garden_widgets.first.value).to eq([value])
          end
        end
      end

      context "with an existing setting" do
        let!(:setting) { Fabricate(:setting, owner: website,
                                             website: website,
                                             name: "row_widget_garden_widgets",
                                             value: ["foo"]) }

        context "before executing update" do
          it "does not have a setting" do
            expect(row_widget_garden_widgets.first.value).to eq(["foo"])
          end
        end

        context "after executing update" do
          before { updater.update(garden_widget) }

          it "updates the row_widget_garden_widgets setting" do
            expect(row_widget_garden_widgets.first.value).to include(value)
          end
        end
      end
    end
  end
end
