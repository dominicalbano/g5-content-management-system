require "spec_helper"

describe GardenWidgetUpdater do
  let(:updater) { GardenWidgetUpdater.new }
  let(:gardener) { GardenWidget }

  describe "#update_all" do
    describe "when a new widget is added to the garden" do
      it "creates new GardenWidget" do
        allow(gardener).to receive(:garden_url).and_return("spec/support/garden_widget_updater/updated.html")
        expect { updater.update_all }.to change { gardener.count }.by(1)
      end
    end

    describe "when a widget is updated in the garden" do
      before do
        allow(gardener).to receive(:garden_url).and_return("spec/support/garden_widget_updater/updated.html")
      end

      context "widget modified reference is AFTER incoming modified component" do
        let(:garden_widget) do
          Fabricate(:garden_widget, name: "Garden Widget",
                    url: "http://widget-garden.com/widget-test", # incoming is equal
                    widget_modified: Time.zone.parse("2010-12-10 00:00:00")) #incoming is after this date
        end

        it "updates GardenWidget name" do
          expect { updater.update_all }.to change { garden_widget.reload.name }.to("Updated Garden Widget")
        end

        it "updates GardenWidget modified" do
          expect { updater.update_all }.to change { garden_widget.reload.widget_modified }.to("2014-11-25 17:25:48 UTC")
        end
      end

      context "widget modified reference is BEFORE incoming modified component" do
        let(:garden_widget) do
          Fabricate(:garden_widget, name: "Garden Widget",
                    url: "http://widget-garden.com/widget-test", # incoming is equal
                    widget_modified: Time.zone.parse("2020-12-10 00:00:00")) # incoming is before this date
        end

        it "updates GardenWidget name" do
          expect { updater.update_all }.to change { garden_widget.reload.name }.to("Updated Garden Widget")
        end

        it "updates GardenWidget modified" do
          expect { updater.update_all }.to change { garden_widget.reload.widget_modified }.to("2014-11-25 17:25:48 UTC")
        end
      end

      context "widget modified reference is EQUAL incoming modified component" do
        let(:garden_widget) do
          Fabricate(:garden_widget, name: "Not Updated Garden Widget",
                    url: "http://widget-garden.com/widget-test", # incoming is equal
                    widget_modified: Time.zone.parse("2014-11-25 17:25:48 UTC")) # incoming is equal
        end

        it "doesn't update GardenWidget name" do
          expect { updater.update_all }.to_not change { garden_widget.reload.name }
        end

        it "doesn't update GardenWidget modified" do
          expect { updater.update_all }.to_not change { garden_widget.reload.widget_modified }
        end

      end

      context "widget url reference is EQUAL incoming component url" do
        let(:garden_widget) do
          Fabricate(:garden_widget, name: "Garden Widget",
                    url: "http://widget-garden.com/widget-test", # incoming is equal
                    widget_modified: Time.zone.parse("2014-11-25 17:25:48 UTC")) # incoming is equal
        end

        it "doesn't update GardenWidget with new name" do
          expect { updater.update_all }.to_not change { garden_widget.reload.name }
        end

        it "doesn't update GardenWidget with new url" do
          expect { updater.update_all }.to_not change { garden_widget.reload.url }
        end
      end

      context "widget url reference is NOT EQUAL incoming component url" do
        let(:garden_widget) do
          Fabricate(:garden_widget, name: "Garden Widget",
                    url: "http://widget-garden.com/staging-widget-test", # incoming is NOT equal
                    widget_modified: Time.zone.parse("2010-12-10 00:00:00")) # incoming is after this date
        end

        it "updates GardenWidget with new name" do
          expect { updater.update_all }.to change { garden_widget.reload.name }.to("Updated Garden Widget")
        end

        it "updates GardenWidget with new url" do
          expect { updater.update_all }.to change { garden_widget.reload.url }.to("http://widget-garden.com/widget-test")
        end
      end

      context "force_all parameter is true - widget url and widget modified are same" do
        let(:garden_widget) do
          Fabricate(:garden_widget, name: "Force All Garden Widget",
                    url: "http://widget-garden.com/widget-test", # incoming is equal
                    widget_modified: Time.zone.parse("2014-11-25 17:25:48 UTC")) # incoming is equal
        end

        it "updates GardenWidget with new name" do
          expect { updater.update_all(true) }.to change { garden_widget.reload.name }
        end

        it "doesn't updates GardenWidget with new url" do
          expect { updater.update_all(true) }.to_not change { garden_widget.reload.url }
        end
      end

    end

    describe "when a widget is removed from the garden" do
      let!(:garden_widget) { Fabricate(:garden_widget, url: "http://widget-garden.com/widget-test") }

      it "destroys GardenWidget with same widget_id" do
        allow(gardener).to receive(:garden_url).and_return("spec/support/garden_widget_updater/removed.html")
        expect { updater.update_all }.to change { gardener.count }.by(-1)
      end
    end

    describe "row_widget garden widgets setting" do
      before do
        allow(gardener).to receive(:garden_url).and_return("spec/support/garden_widget_updater/updated.html")
      end
      let(:garden_widget) do
        Fabricate(:garden_widget, url: "spec/support/garden_widget_updater/widget-test/updated.html")
      end
      let!(:website) { Fabricate(:website) }
      
      context "with no existing setting" do
        context "before executing update" do
          it "does not have a setting" do
            row_widget_garden_widgets = website.settings.where(name: "row_widget_garden_widgets")
            expect(row_widget_garden_widgets).to be_empty
          end
        end

        context "after executing update" do
          it "creates the row_widget_garden_widgets setting" do
            updater.update_all
            row_widget_garden_widgets = website.settings.where(name: "row_widget_garden_widgets").first
            expect(row_widget_garden_widgets.value).to eq(['Updated Garden Widget'])
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
            row_widget_garden_widgets = website.settings.where(name: "row_widget_garden_widgets").first
            expect(row_widget_garden_widgets.value).to eq(["foo"])
          end
        end

        context "after executing update" do
          before { updater.update_all }

          it "updates the row_widget_garden_widgets setting" do
            row_widget_garden_widgets = website.settings.where(name: "row_widget_garden_widgets").first
            expect(row_widget_garden_widgets.value).to include("Updated Garden Widget")
          end
        end
      end
    end

  end

  describe "#update" do
    let(:garden_widget) do
      Fabricate(:garden_widget, url: "spec/support/garden_widget_updater/widget-test/updated.html")
    end

    describe "GardenWidget attributes" do
      before do
        updater.send(:update, garden_widget)
      end

      it "sets url" do
        expect(garden_widget.url).to eq "http://widget-garden.com/widget-test"
      end

      it "sets name" do
        expect(garden_widget.name).to eq "Updated Garden Widget"
      end

      it "sets widget_id" do
        expect(garden_widget.widget_id).to eq 1
      end

      it "sets widget_type" do
        expect(garden_widget.widget_type).to eq "G5 Internal"
      end

      it "sets thumbnail" do
        expect(garden_widget.thumbnail).to eq "http://widget-garden.com/widget-test/images/thumbnail.png"
      end

      it "sets liquid" do
        expect(garden_widget.liquid).to eq true
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
    
      it "sets widget_modified" do
        expect(garden_widget.widget_modified).to eq Time.zone.parse("2014-11-25 17:25:48 UTC")
      end
    end

    describe "Widget settings" do
      it "creates a new setting" do
        widget = Fabricate(:widget, garden_widget: garden_widget)
        expect { updater.send(:update, garden_widget) }.to change { Setting.count }.by(1)
        expect(widget.reload.settings.first.name).to eq "text"
      end

      it "updates an existing setting with the same name" do
        widget = Fabricate(:widget, garden_widget: garden_widget)
        setting = Fabricate(:setting, name: "text", owner: widget)
        expect { updater.send(:update, garden_widget) }.not_to change { Setting.count }
        expect(setting.reload.default_value).to eq "Lorem ipsum."
      end

      it "removes old settings" do
        widget = Fabricate(:widget, garden_widget: garden_widget)
        setting = Fabricate(:setting, name: "text", owner: widget)
        setting = Fabricate(:setting, name: "old", owner: widget)
        expect { updater.send(:update, garden_widget) }.to change { Setting.count }.by(-1)
      end
    end 
  end
end
