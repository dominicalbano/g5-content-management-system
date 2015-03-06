require "spec_helper"

describe "Integration '/:website_slug/:web_page_template_slug/edit'",
         auth_request: true, integration: true, js: true, vcr: VCR_OPTIONS do
  before do
    VCR.use_cassette("Gardens") do
      GardenWebLayoutUpdater.new.update_all
      GardenWebThemeUpdater.new.update_all
      GardenWidgetUpdater.new.update_all
    end

    @client, @location, @website = seed
    @web_page_template = @website.web_page_templates.first
    @website_template = @website.website_template
    @web_theme = @website_template.web_theme
  end

  describe "initial page load" do
    before do
      visit "/#{@website.slug}/#{@web_page_template.slug}/edit"
    end

    it "collapses all gardens" do
      page.should have_selector('.theme-picker .toggle-content', visible: false)
      page.should have_selector('.layout-picker .toggle-content', visible: false)
      page.should have_selector('.widget-list .toggle-content', visible: false)
    end
  end

  describe "themes" do
    before do
      visit "/#{@website.slug}/#{@web_page_template.slug}/edit"
      open_gardens
    end

    it "hides unused themes" do
      page.should have_selector('.unused-theme', visible: false)
      page.should have_selector('.used-theme', visible: true)
    end
  end

  describe "Authorization" do
    before do
      visit "/#{@website.slug}/#{@web_page_template.slug}/edit"
      open_gardens
    end

    context "client user" do
      it "has a body class" do
        expect(find("body.client-user")).to_not be_nil
      end

      context "verticals" do
        it "multifamily" do
          expect(find("div.apartments-client")).to_not be_nil
          page.should have_selector('.builder.apartments-client .widget.self-storage-feature', visible: false)
          page.should have_selector('.builder.apartments-client .widget:not(.self-storage-feature)', visible: true)
        end
      end

      context "widgets" do
        it "has classes" do
          page.should have_selector('.builder.apartments-client .widget.g5-internal-feature', visible: false)
          page.should have_selector('.builder.apartments-client .widget:not(.g5-internal-feature)', visible: true)
        end
      end

      context "layouts" do
        it "hides unused layouts" do
          pending("Irrelevant until clients have access to layout garden")
          page.should have_selector('.unused-layout', visible: false)
          page.should have_selector('.used-layout', visible: true)
        end
      end
    end

    context "g5 user" do
      let(:user) { FactoryGirl.create(:g5_authenticatable_user, email: "test@getg5.com") }

      it "has a body class" do
        expect(find("body.g5-user")).to_not be_nil
      end

      context "verticals" do
        it "multifamily" do
          expect(find("div.apartments-client")).to_not be_nil
          page.should have_selector('.builder.apartments-client .widget.self-storage-feature', visible: true)
          page.should have_selector('.builder.apartments-client .widget:not(.self-storage-feature)', visible: true)
        end
      end

      context "widgets" do
        it "has classes" do
          page.should have_selector('.builder.apartments-client .widget.g5-internal-feature', visible: true)
          page.should have_selector('.builder.apartments-client .widget:not(.g5-internal-feature)', visible: true)
        end
      end

      context "layouts" do
        it "shows used and unused layouts" do
          # All layouts hidden until we are using more than just 1
          page.should have_selector('.unused-layout', visible: false)
          page.should have_selector('.used-layout', visible: false)
        end
      end
    end
  end

  describe "dynamic vertical class" do
    context "storage" do
      before do
        @client.update_attribute(:vertical, "foo")
        visit "/#{@website.slug}/#{@web_page_template.slug}/edit"
      end

      it "storage" do
        expect(find("div.foo-client")).to_not be_nil
      end
    end
  end

  describe "Color picker" do
    before do
      visit "/#{@website.slug}/#{@web_page_template.slug}/edit"
      open_gardens
    end

    describe "Theme selection" do
      let(:primary_color) { @web_theme.primary_color }
      let(:secondary_color) { @web_theme.secondary_color }
      let(:tertiary_color) { @web_theme.tertiary_color }
      let(:html_primary_color) { find('#color-1', :visible => false).text }
      let(:html_secondary_color) { find('#color-2', :visible => false).text }
      let(:html_tertiary_color) { "#000" }
      let(:garden_theme) { find('.theme-picker .thumb:first-of-type') }

      context "accepting the confirm dialog" do
        it "Will update with theme colors when theme changes" do
          garden_theme.click

          expect(@website.reload.website_template).to_not eq @web_theme
          expect(primary_color).to_not eq html_primary_color
          expect(secondary_color).to_not eq html_secondary_color
          expect(tertiary_color).to_not eq html_tertiary_color
        end
      end

      context "dismissing the confirm dialog" do
        it "Will not update the theme" do
          garden_theme.click

          expect(@website.reload.website_template.web_theme).to eq @web_theme
        end
      end
    end
  end

  describe "Main widgets" do
    describe "Are drag and drop addable" do
      before do
        visit "/#{@website.slug}/#{@web_page_template.slug}/edit"
      end

      it "Creates a new widget in the database and displays in DOM" do
        pending("TODO: Fix intermittent failure")

        garden_widget = find(".widget-list .widget-view .widget:last-of-type")
        drop_target_add = find(".main-widgets .drop-target-add:first-of-type")
        existing_widget_count = all(".main-widgets .widget").length

        expect do
          drag_and_drop_add(garden_widget, drop_target_add)
          sleep 1
        end.to change{ @web_page_template.reload.main_widgets.count }.by(1)
        expect(all(".main-widgets .widget").length).to eq existing_widget_count + 1
      end
    end

    describe "Are drag and drop sortable" do
      before do
        @widget1 = @web_page_template.main_widgets.first
        @widget2 = @web_page_template.main_widgets.last

        # Make sure widgets are ordered first and last
        @widget1.update_attribute :display_order, :first
        @widget2.update_attribute :display_order, :last

        visit "/#{@website.slug}/#{@web_page_template.slug}/edit"
      end

      it "Updates display order in database" do
        within ".main-widgets" do
          widget1 = find(".widget:first-of-type")
          widget2 = find(".widget:last-of-type")
          expect(@widget2.display_order > @widget1.display_order).to be_truthy
          drag_and_drop_below(widget1, widget2)
          sleep 1
          expect(@widget2.reload.display_order < @widget1.reload.display_order).to be_truthy
        end
      end
    end

    describe "editable" do
      before do
        @widget1 = @web_page_template.main_widgets.first
        visit "/#{@website.slug}/#{@web_page_template.slug}/edit"
      end

      it "has a dynamic heading" do
        within ".main-widgets" do
          widget1 = find(".widget:first-of-type")
          widget1.click
          sleep 1
          expect(page.driver.find_css("#myModalLabel").first.visible_text).to eq("Edit #{@widget1.name}".upcase)
        end
      end
    end

    describe "Are drag and drop removeable" do
      before do
        visit "/#{@website.slug}/#{@web_page_template.slug}/edit"
      end

      describe "When widgets exist on page load" do
        it "Destroys an existing widget in the database and updates DOM" do
          existing_widget = find(".main-widgets .widget:first-of-type")
          drop_target_remove = find(".main-widgets .remove-drop-zone")
          existing_widget_count = all(".main-widgets .widget").length

          expect do
            drag_and_drop(existing_widget, drop_target_remove)
            accept_confirm(page)
            sleep 1
          end.to change{ @web_page_template.reload.main_widgets.count }.by(-1)
          expect(all(".main-widgets .widget").length).to eq existing_widget_count-1
        end

        it "Destroys multiple existing widgets in the database and updates DOM" do
          drop_target_remove = find(".main-widgets .drop-target-remove:first-of-type")
          existing_widget_count = all(".main-widgets .widget").length

          expect do
            2.times do
              existing_widget = find(".main-widgets .widget:first-of-type")
              drag_and_drop(existing_widget, drop_target_remove)
              iframe= find("iframe")
              sleep 5
              accept_confirm(page)
              sleep 1
            end
          end.to change{ @web_page_template.reload.main_widgets.count }.by(-2)
          expect(all(".main-widgets .widget").length).to eq existing_widget_count-2
        end
      end

      describe "When widgets are added after page load" do
        before do
          open_gardens
          garden_widget = find(".widget-list .widget-view .widget:last-of-type")
          drop_target_add = find(".main-widgets .drop-target-add:first-of-type")
          2.times do
            drag_and_drop(garden_widget, drop_target_add)
            sleep 1
          end
        end

        it "Destroys an existing widget in the database and updates DOM" do
          existing_widget = find(".main-widgets .widget:last-of-type")
          drop_target_remove = find(".main-widgets .drop-target-remove:first-of-type")
          existing_widget_count = all(".main-widgets .widget").length

          expect do
            drag_and_drop(existing_widget, drop_target_remove)
            accept_confirm(page)
            sleep 1
          end.to change{ @web_page_template.reload.main_widgets.count }.by(-1)
          expect(all(".main-widgets .widget").length).to eq existing_widget_count-1
        end

        it "Destroys multiple existing widgets in the database and updates DOM" do
          drop_target_remove = find(".main-widgets .drop-target-remove:first-of-type")
          existing_widget_count = all(".main-widgets .widget").length

          expect do
            2.times do
              existing_widget = find(".main-widgets .widget:last-of-type")
              drag_and_drop(existing_widget, drop_target_remove)
              accept_confirm(page)
              sleep 1
            end
          end.to change{ @web_page_template.reload.main_widgets.count }.by(-2)
          expect(all(".main-widgets .widget").length).to eq existing_widget_count-2
        end
      end
    end
  end

  describe "Aside before main widgets" do
    describe "Are drag and drop addable" do
      before do
        visit "/#{@website.slug}/#{@web_page_template.slug}/edit"
        open_gardens
      end

      it "Creates a new widget in the database and displays in DOM" do
        # intermittent
        garden_widget = find(".widget-list .widget-view .widget:last-of-type")
        drop_target_add = find(".aside-before-main-widgets .drop-target-add:first-of-type")
        existing_widget_count = all(".aside-before-main-widgets .widget").length

        expect do
          drag_and_drop_add(garden_widget, drop_target_add)
          sleep 1
        end.to change{ @website_template.reload.aside_before_main_widgets.count }.by(1)
        expect(all(".aside-before-main-widgets .widget").length).to eq existing_widget_count + 1
      end
    end

    describe "Are drag and drop sortable" do
      before do
        @widget1 = @website_template.aside_before_main_widgets.first
        @widget2 = @website_template.aside_before_main_widgets.last

        # Make sure widgets are ordered first and last
        @widget1.update_attribute :display_order, :first
        @widget2.update_attribute :display_order, :last

        visit "/#{@website.slug}/#{@web_page_template.slug}/edit"
      end

      it "Updates display order in database" do
        within ".aside-before-main-widgets" do
          widget1 = find(".widget:first-of-type")
          widget2 = find(".widget:last-of-type")
          expect(@widget2.display_order > @widget1.display_order).to be_truthy
          drag_and_drop_below(widget1, widget2)
          sleep 1
          expect(@widget2.reload.display_order < @widget1.reload.display_order).to be_truthy
        end
      end
    end

    describe "editable" do
      before do
        @widget1 = @website_template.aside_before_main_widgets.first
        visit "/#{@website.slug}/#{@web_page_template.slug}/edit"
      end

      it "has a dynamic heading" do
        within ".aside-before-main-widgets" do
          widget1 = find(".widget:first-of-type")
          widget1.click
          sleep 1
          expect(page.driver.find_css("#myModalLabel").first.visible_text).to eq("Edit #{@widget1.name}".upcase)
        end
      end
    end

    describe "Are drag and drop removeable" do
      before do
        visit "/#{@website.slug}/#{@web_page_template.slug}/edit"
      end

      describe "When widgets exist on page load" do
        it "Destroys an existing widget in the database and updates DOM" do
          existing_widget = find(".aside-before-main-widgets .widget:first-of-type")
          drop_target_remove = find(".aside-before-main-widgets .drop-target-remove:first-of-type")
          existing_widget_count = all(".aside-before-main-widgets .widget").length

          expect do
            drag_and_drop(existing_widget, drop_target_remove)
            accept_confirm(page)
            sleep 1
          end.to change{ @website_template.reload.aside_before_main_widgets.count }.by(-1)
          expect(all(".aside-before-main-widgets .widget").length).to eq existing_widget_count-1
        end

        it "Destroys multiple existing widgets in the database and updates DOM" do
          drop_target_remove = find(".aside-before-main-widgets .drop-target-remove:first-of-type")
          existing_widget_count = all(".aside-before-main-widgets .widget").length

          expect do
            2.times do
              existing_widget = find(".aside-before-main-widgets .widget:first-of-type")
              drag_and_drop(existing_widget, drop_target_remove)
              accept_confirm(page)
              sleep 1
            end
          end.to change{ @website_template.reload.aside_before_main_widgets.count }.by(-2)
          expect(all(".aside-before-main-widgets .widget").length).to eq existing_widget_count-2
        end
      end

      describe "When widgets are added after page load" do
        before do
          open_gardens
          garden_widget = find(".widget-list .widget-view .widget:last-of-type")
          drop_target_add = find(".aside-before-main-widgets .drop-target-add:first-of-type")
          2.times do
            drag_and_drop(garden_widget, drop_target_add)
            sleep 1
          end
        end

        it "Destroys an existing widget in the database and updates DOM" do
          existing_widget = find(".aside-before-main-widgets .widget:last-of-type")
          drop_target_remove = find(".aside-before-main-widgets .drop-target-remove:first-of-type")
          existing_widget_count = all(".aside-before-main-widgets .widget").length

          expect do
            drag_and_drop(existing_widget, drop_target_remove)
            accept_confirm(page)
            sleep 1
          end.to change{ @website_template.reload.aside_before_main_widgets.count }.by(-1)
          expect(all(".aside-before-main-widgets .widget").length).to eq existing_widget_count-1
        end

        it "Destroys multiple existing widgets in the database and updates DOM" do
          # intermittent
          drop_target_remove = find(".aside-before-main-widgets .drop-target-remove:first-of-type")
          existing_widget_count = all(".aside-before-main-widgets .widget").length

          expect do
            2.times do
              existing_widget = find(".aside-before-main-widgets .widget:last-of-type")
              drag_and_drop(existing_widget, drop_target_remove)
              accept_confirm(page)
              sleep 1
            end
          end.to change{ @website_template.reload.aside_before_main_widgets.count }.by(-2)
          expect(all(".aside-before-main-widgets .widget").length).to eq existing_widget_count-2
        end
      end
    end
  end

  describe "Aside after main widgets" do
    describe "Are drag and drop addable" do
      before do
        visit "/#{@website.slug}/#{@web_page_template.slug}/edit"
        open_gardens
      end

      it "Creates a new widget in the database and displays in DOM" do
        # intermittent
        garden_widget = find(".widget-list .widget-view .widget:last-of-type")
        drop_target_add = find(".aside-after-main-widgets .add-drop-zone:first-of-type")
        existing_widget_count = all(".aside-after-main-widgets .widget").length

        expect do
          drag_and_drop_add(garden_widget, drop_target_add)
          sleep 1
        end.to change{ @website_template.reload.aside_after_main_widgets.count }.by(1)
        expect(all(".aside-after-main-widgets .widget").length).to eq existing_widget_count + 1
      end
    end

    describe "Are drag and drop sortable" do
      before do
        @widget1 = @website_template.aside_after_main_widgets.first
        @widget2 = @website_template.aside_after_main_widgets.last

        # Make sure widgets are ordered first and last
        @widget1.update_attribute :display_order, :first
        @widget2.update_attribute :display_order, :last

        visit "/#{@website.slug}/#{@web_page_template.slug}/edit"
      end

      it "Updates display order in database" do
        within ".aside-after-main-widgets" do
          widget1 = find(".widget:first-of-type")
          widget2 = find(".widget:last-of-type")
          expect(@widget2.display_order > @widget1.display_order).to be_truthy
          drag_and_drop_below(widget1, widget2)
          sleep 1
          expect(@widget2.reload.display_order < @widget1.reload.display_order).to be_truthy
        end
      end
    end

    describe "editable" do
      before do
        @widget1 = @website_template.aside_after_main_widgets.first
        visit "/#{@website.slug}/#{@web_page_template.slug}/edit"
      end

      it "has a dynamic heading" do
        within ".aside-after-main-widgets" do
          widget1 = find(".widget:first-of-type")
          widget1.click
          sleep 1
          expect(page.driver.find_css("#myModalLabel").first.visible_text).to eq("Edit #{@widget1.name}".upcase)
        end
      end
    end

    describe "Are drag and drop removeable" do
      before do
        visit "/#{@website.slug}/#{@web_page_template.slug}/edit"
      end

      describe "When widgets exist on page load" do
        it "Destroys an existing widget in the database and updates DOM" do
          existing_widget = find(".aside-after-main-widgets .widget:first-of-type")
          drop_target_remove = find(".aside-after-main-widgets .drop-target-remove:first-of-type")
          existing_widget_count = all(".aside-after-main-widgets .widget").length

          expect do
            drag_and_drop(existing_widget, drop_target_remove)
            accept_confirm(page)
            sleep 1
          end.to change{ @website_template.reload.aside_after_main_widgets.count }.by(-1)
          expect(all(".aside-after-main-widgets .widget").length).to eq existing_widget_count-1
        end

        it "Destroys multiple existing widgets in the database and updates DOM" do
          drop_target_remove = find(".aside-after-main-widgets .drop-target-remove:first-of-type")
          existing_widget_count = all(".aside-after-main-widgets .widget").length

          expect do
            2.times do
              existing_widget = find(".aside-after-main-widgets .widget:first-of-type")
              drag_and_drop(existing_widget, drop_target_remove)
              accept_confirm(page)
              sleep 1
            end
          end.to change{ @website_template.reload.aside_after_main_widgets.count }.by(-2)
          expect(all(".aside-after-main-widgets .widget").length).to eq existing_widget_count-2
        end
      end

      describe "When widgets are added after page load" do
        before do
          open_gardens
          garden_widget = find(".widget-list .widget-view .widget:last-of-type")
          drop_target_add = find(".aside-after-main-widgets .drop-target-add:first-of-type")
          2.times do
            drag_and_drop(garden_widget, drop_target_add)
            sleep 1
          end
        end

        it "Destroys an existing widget in the database and updates DOM" do
          existing_widget = find(".aside-after-main-widgets .widget:last-of-type")
          drop_target_remove = find(".aside-after-main-widgets .drop-target-remove:first-of-type")
          existing_widget_count = all(".aside-after-main-widgets .widget").length

          expect do
            drag_and_drop(existing_widget, drop_target_remove)
            accept_confirm(page)
            sleep 1
          end.to change{ @website_template.reload.aside_after_main_widgets.count }.by(-1)
          expect(all(".aside-after-main-widgets .widget").length).to eq existing_widget_count-1
        end

        it "Destroys multiple existing widgets in the database and updates DOM" do
          drop_target_remove = find(".aside-after-main-widgets .drop-target-remove:first-of-type")
          existing_widget_count = all(".aside-after-main-widgets .widget").length

          expect do
            2.times do
              existing_widget = find(".aside-after-main-widgets .widget:last-of-type")
              drag_and_drop(existing_widget, drop_target_remove)
              accept_confirm(page)
              sleep 1
            end
          end.to change{ @website_template.reload.aside_after_main_widgets.count }.by(-2)
          expect(all(".aside-after-main-widgets .widget").length).to eq existing_widget_count-2
        end
      end
    end
  end
end
