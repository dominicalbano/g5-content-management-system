require "spec_helper"

describe "Integration '/:website_slug/:web_page_template_slug'",
         auth_request: true, integration: true, js: true, vcr: VCR_OPTIONS, retry: 3 do
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

  describe "themes", skip: "Theme Poltergiest fails intermittently." do
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
      let(:garden_theme) { find('.theme-picker .thumb:first-of-type') }

      context "accepting the confirm dialog" do
        it "Will update with theme colors when theme changes" do
          garden_theme.trigger('click')

          expect(@website.reload.website_template).to_not eq @web_theme
        end
      end

      context "dismissing the confirm dialog" do
        it "Will not update the theme" do
          garden_theme.trigger('click')

          expect(@website.reload.website_template.web_theme).to eq @web_theme
        end
      end
    end
  end

  describe "Main widgets" do
    describe "Are drag and drop addable", skip: "Drag and drop specs fail intermittently." do
      before do
        visit "/#{@website.slug}/#{@web_page_template.slug}/edit"
      end

      it "Creates a new widget in the database and displays in DOM" do
        open_gardens
        garden_widget = ".widget-list .widgets--list-view .widget:last-of-type"
        drop_target_add = ".main-widgets .drop-target-add:first-of-type"
        existing_widget_count = all(".main-widgets .widget").length

        expect do
          drag_and_drop(garden_widget, drop_target_add)
          sleep 1
        end.to change{ @web_page_template.reload.main_widgets.count }.by(1)
        expect(all(".main-widgets .widget").length).to eq existing_widget_count + 1
      end
    end

    describe "Widget has a Popover" do
      before do
        visit "/#{@website.slug}/#{@web_page_template.slug}/edit"
        open_gardens
      end

      it "a popover gets inserted into the page when a widet item is clicked" do
        garden_widget = find(".widget-list .widget-view .widget:last-of-type")
        garden_widget.trigger('click')

        page.should have_selector('h3.popover-title', visible: true)
      end

      it "a popover title matches the name of the widget that was clicked" do
        #find the last widget object above the main widget area.
        garden_widget = find(".widget-list .widget-view .new-widget:last-of-type")
        @widget_text = garden_widget.text
        garden_widget.trigger('click')
        popover = find('h3.popover-title') 

        popover.should have_content("#{@widget_text}")
      end
    end

    describe "Are drag and drop sortable", skip: "Drag and drop specs fail intermittently." do
      before do
        @widget1 = @web_page_template.main_widgets.first
        @widget2 = @web_page_template.main_widgets.last

        # Make sure widgets are ordered first and last
        @widget1.update_attribute :display_order, :first
        @widget2.update_attribute :display_order, :last

        visit "/#{@website.slug}/#{@web_page_template.slug}/edit"
      end

      it "Updates display order in database" do
        widget1 = ".main-widgets .widget:first-of-type"
        widget2 = ".main-widgets .widget:last-of-type"
        expect(@widget2.display_order > @widget1.display_order).to be_truthy
        drag_and_drop_below(widget1, widget2)
        sleep 1
        expect(@widget2.reload.display_order < @widget1.reload.display_order).to be_truthy
      end
    end

    describe "editable", skip: "Title specs fail intermittently." do
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
          existing_widget = ".main-widgets .widget:first-of-type"
          drop_target_remove = ".main-widgets .remove-drop-zone"
          existing_widget_count = find(".main-widgets").all(".widget").length

          accept_confirm do
            drag_and_drop(existing_widget, drop_target_remove)
            sleep(1.0/2.0)
          end
          wait_until{@web_page_template.reload.main_widgets.count == 1}
          expect(find(".main-widgets").all(".widget").length).to eq existing_widget_count-1
        end

        it "Destroys multiple existing widgets in the database and updates DOM" do
          existing_widget = ".main-widgets .widget:first-of-type"
          drop_target_remove = ".main-widgets .drop-target-remove:first-of-type"
          existing_widget_count = find(".main-widgets").all(".widget").length

          accept_confirm do
            drag_and_drop(existing_widget, drop_target_remove)
            sleep(1.0/2.0)
          end
          sleep 10
          wait_until{@web_page_template.reload.main_widgets.count == (existing_widget_count - 1)}
          accept_confirm do
            drag_and_drop(existing_widget, drop_target_remove)
            sleep(1.0/2.0)
          end
          wait_until{@web_page_template.reload.main_widgets.count == (existing_widget_count - 2)}
          expect(@web_page_template.reload.main_widgets.count).to eq(existing_widget_count - 2)
          expect(find(".main-widgets").all(".widget").length).to eq (existing_widget_count - 2)
        end
      end

      describe "When widgets are added after page load" do

        context "single widget" do
          before do
            open_gardens
            garden_widget = ".widget-list .widgets--list-view .widget:last-of-type"
            drop_target_add = ".main-widgets .drop-target-add:first-of-type"
                
            existing_widget_count = @web_page_template.reload.main_widgets.count

            drag_and_drop(garden_widget, drop_target_add)
            sleep 10
            #wait_until{@web_page_template.reload.main_widgets.count == (existing_widget_count + 1)}

            drag_and_drop(garden_widget, drop_target_add)
            sleep 10
            #wait_until{@web_page_template.reload.main_widgets.count == (existing_widget_count + 2)}
          end

          it "Destroys an existing widget in the database and updates DOM" do
            existing_widget = ".main-widgets .widget:last-of-type"
            drop_target_remove = ".main-widgets .drop-target-remove:first-of-type"
            existing_widget_count = find(".main-widgets").all(".widget").length

            accept_confirm do
              drag_and_drop(existing_widget, drop_target_remove)
              sleep(1)
            end
            wait_until{@web_page_template.reload.main_widgets.count == (existing_widget_count - 1)}

            expect(@web_page_template.reload.main_widgets.count).to eq existing_widget_count - 1
            expect(all(".main-widgets .widget").length).to eq existing_widget_count - 1
          end
        end
        context "multiple widgets" do
          before do
            open_gardens
            garden_widget = ".widget-list .widgets--list-view .widget:last-of-type"
            drop_target_add = ".main-widgets .drop-target-add:first-of-type"
                
            existing_widget_count = @web_page_template.reload.main_widgets.count

            drag_and_drop(garden_widget, drop_target_add)
            sleep 10
            #wait_until{@web_page_template.reload.main_widgets.count == (existing_widget_count + 1)}

            drag_and_drop(garden_widget, drop_target_add)
            sleep 10
            #wait_until{@web_page_template.reload.main_widgets.count == (existing_widget_count + 2)}
          end
          it "Destroys multiple existing widgets in the database and updates DOM" do
            existing_widget = ".main-widgets .widget:last-of-type"
            drop_target_remove = ".main-widgets .drop-target-remove:first-of-type"
            existing_widget_count = find(".main-widgets").all(".widget").length

            accept_confirm do
              drag_and_drop(existing_widget, drop_target_remove)
              sleep(0.5)
            end
            wait_until{@web_page_template.reload.main_widgets.count == (existing_widget_count - 1)}
            accept_confirm do
              drag_and_drop(existing_widget, drop_target_remove)
              sleep(0.5)
            end
            wait_until{@web_page_template.reload.main_widgets.count == (existing_widget_count - 2)}
            expect(all(".main-widgets .widget").length).to eq existing_widget_count-2
          end
        end

      end
    end
  end

  describe "Aside before main widgets" do
    describe "Are drag and drop addable", skip: "Drag and drop specs fail intermittently." do
      before do
        visit "/#{@website.slug}/#{@web_page_template.slug}/edit"
        open_gardens
      end

      it "Creates a new widget in the database and displays in DOM" do
        garden_widget = ".widget-list .widgets--list-view .widget:last-of-type"
        drop_target_add = ".aside-before-main-widgets .drop-target-add:first-of-type"
        existing_widget_count = all(".aside-before-main-widgets .widget").length

        expect do
          drag_and_drop(garden_widget, drop_target_add)
          sleep 1
        end.to change{ @website_template.reload.aside_before_main_widgets.count }.by(1)
        expect(all(".aside-before-main-widgets .widget").length).to eq existing_widget_count + 1
      end
    end

    describe "Are drag and drop sortable", skip: "Drag and drop specs fail intermittently." do
      before do
        @widget1 = @website_template.aside_before_main_widgets.first
        @widget2 = @website_template.aside_before_main_widgets.last

        # Make sure widgets are ordered first and last
        @widget1.update_attribute :display_order, :first
        @widget2.update_attribute :display_order, :last

        visit "/#{@website.slug}/#{@web_page_template.slug}/edit"
      end

      it "Updates display order in database" do
        widget1 = ".aside-before-main-widgets .widget:first-of-type"
        widget2 = ".aside-before-main-widgets .widget:last-of-type"
        expect(@widget2.display_order > @widget1.display_order).to be_truthy
        drag_and_drop_below(widget1, widget2)
        sleep 1
        expect(@widget2.reload.display_order < @widget1.reload.display_order).to be_truthy
      end
    end

    describe "editable" do
      before do
        @widget1 = @website_template.aside_before_main_widgets.first
        visit "/#{@website.slug}/#{@web_page_template.slug}/edit"
      end

      it "has a dynamic heading", skip: "Modal title fail intermittently." do
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

      describe "When widgets exist on page load", skip: "Drag and drop specs fail intermittently." do
        it "Destroys an existing widget in the database and updates DOM" do
          existing_widget = ".aside-before-main-widgets .widget:first-of-type"
          drop_target_remove = ".aside-before-main-widgets .drop-target-remove:first-of-type"
          existing_widget_count = all(".aside-before-main-widgets .widget").length

          expect do
            accept_confirm do
              drag_and_drop(existing_widget, drop_target_remove)
            end
            sleep 1
          end.to change{ @website_template.reload.aside_before_main_widgets.count }.by(-1)
          expect(all(".aside-before-main-widgets .widget").length).to eq existing_widget_count-1
        end

        it "Destroys multiple existing widgets in the database and updates DOM" do
          existing_widget = ".aside-before-main-widgets .widget:first-of-type"
          drop_target_remove = ".aside-before-main-widgets .drop-target-remove:first-of-type"
          existing_widget_count = all(".aside-before-main-widgets .widget").length

          expect do
            2.times do
              accept_confirm do
                drag_and_drop(existing_widget, drop_target_remove)
              end
              sleep 1
            end
          end.to change{ @website_template.reload.aside_before_main_widgets.count }.by(-2)
          expect(all(".aside-before-main-widgets .widget").length).to eq existing_widget_count-2
        end
      end

      describe "When widgets are added after page load", skip: "Drag and drop specs fail intermittently." do
        before do
          open_gardens
          garden_widget = ".widget-list .widgets--list-view .widget:last-of-type"
          drop_target_add = ".aside-before-main-widgets .drop-target-add:first-of-type"
          2.times do
            drag_and_drop(garden_widget, drop_target_add)
            sleep 1
          end
        end

        it "Destroys an existing widget in the database and updates DOM" do
          existing_widget = ".aside-before-main-widgets .widget:last-of-type"
          drop_target_remove = ".aside-before-main-widgets .drop-target-remove:first-of-type"
          existing_widget_count = all(".aside-before-main-widgets .widget").length

          expect do
            accept_confirm do
              drag_and_drop(existing_widget, drop_target_remove)
            end
            sleep 1
          end.to change{ @website_template.reload.aside_before_main_widgets.count }.by(-1)
          expect(all(".aside-before-main-widgets .widget").length).to eq existing_widget_count-1
        end

        it "Destroys multiple existing widgets in the database and updates DOM" do
          existing_widget = ".aside-before-main-widgets .widget:last-of-type"
          drop_target_remove = ".aside-before-main-widgets .drop-target-remove:first-of-type"
          existing_widget_count = all(".aside-before-main-widgets .widget").length

          expect do
            2.times do
              accept_confirm do
                drag_and_drop(existing_widget, drop_target_remove)
              end
              sleep 1
            end
          end.to change{ @website_template.reload.aside_before_main_widgets.count }.by(-2)
          expect(all(".aside-before-main-widgets .widget").length).to eq existing_widget_count-2
        end
      end
    end
  end

  describe "Aside after main widgets" do
    describe "Are drag and drop addable", skip: "Drag and drop specs fail intermittently." do
      before do
        visit "/#{@website.slug}/#{@web_page_template.slug}/edit"
        open_gardens
      end

      it "Creates a new widget in the database and displays in DOM" do
        garden_widget = ".widget-list .widgets--list-view .widget:last-of-type"
        drop_target_add = ".aside-after-main-widgets .add-drop-zone:first-of-type"
        existing_widget_count = all(".aside-after-main-widgets .widget").length

        expect do
          drag_and_drop(garden_widget, drop_target_add)
          sleep 1
        end.to change{ @website_template.reload.aside_after_main_widgets.count }.by(1)
        expect(all(".aside-after-main-widgets .widget").length).to eq existing_widget_count + 1
      end
    end

    describe "Are drag and drop sortable", skip: "Drag and drop specs fail intermittently." do
      before do
        @widget1 = @website_template.aside_after_main_widgets.first
        @widget2 = @website_template.aside_after_main_widgets.last

        # Make sure widgets are ordered first and last
        @widget1.update_attribute :display_order, :first
        @widget2.update_attribute :display_order, :last

        visit "/#{@website.slug}/#{@web_page_template.slug}/edit"
      end

      it "Updates display order in database" do
        widget1 = ".aside-after-main-widgets .widget:first-of-type"
        widget2 = ".aside-after-main-widgets .widget:last-of-type"
        expect(@widget2.display_order > @widget1.display_order).to be_truthy
        drag_and_drop_below(widget1, widget2)
        sleep 1
        expect(@widget2.reload.display_order < @widget1.reload.display_order).to be_truthy
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

      describe "When widgets exist on page load", skip: "Drag and drop specs fail intermittently." do
        it "Destroys an existing widget in the database and updates DOM" do
          existing_widget = ".aside-after-main-widgets .widget:first-of-type"
          drop_target_remove = ".aside-after-main-widgets .drop-target-remove:first-of-type"
          existing_widget_count = all(".aside-after-main-widgets .widget").length

          expect do
            accept_confirm do
              drag_and_drop(existing_widget, drop_target_remove)
            end
            sleep 1
          end.to change{ @website_template.reload.aside_after_main_widgets.count }.by(-1)
          expect(all(".aside-after-main-widgets .widget").length).to eq existing_widget_count-1
        end

        it "Destroys multiple existing widgets in the database and updates DOM", skip: "Drag and drop specs fail intermittently." do
          existing_widget = ".aside-after-main-widgets .widget:first-of-type"
          drop_target_remove = ".aside-after-main-widgets .drop-target-remove:first-of-type"
          existing_widget_count = all(".aside-after-main-widgets .widget").length

          expect do
            2.times do
              accept_confirm do
                drag_and_drop(existing_widget, drop_target_remove)
              end
              sleep 1
            end
          end.to change{ @website_template.reload.aside_after_main_widgets.count }.by(-2)
          expect(all(".aside-after-main-widgets .widget").length).to eq(existing_widget_count - 2)
        end
      end

      describe "When widgets are added after page load" do
        before do
          open_gardens
          garden_widget = ".widget-list .widgets--list-view .widget:last-of-type"
          drop_target_add = ".aside-after-main-widgets .drop-target-add:first-of-type"
          2.times do
            drag_and_drop(garden_widget, drop_target_add)
            sleep 1
          end
        end

        it "Destroys an existing widget in the database and updates DOM" do
          existing_widget = ".aside-after-main-widgets .widget:last-of-type"
          drop_target_remove = ".aside-after-main-widgets .drop-target-remove:first-of-type"
          existing_widget_count = all(".aside-after-main-widgets .widget").length

          expect do
            accept_confirm do
              drag_and_drop(existing_widget, drop_target_remove)
            end
            sleep 1
          end.to change{ @website_template.reload.aside_after_main_widgets.count }.by(-1)
          expect(all(".aside-after-main-widgets .widget").length).to eq existing_widget_count-1
        end

        it "Destroys multiple existing widgets in the database and updates DOM" do
          existing_widget = ".aside-after-main-widgets .widget:last-of-type"
          drop_target_remove = ".aside-after-main-widgets .drop-target-remove:first-of-type"
          existing_widget_count = all(".aside-after-main-widgets .widget").length

          expect do
            2.times do
              accept_confirm do
                drag_and_drop(existing_widget, drop_target_remove)
              end
              sleep 1
            end
          end.to change{ @website_template.reload.aside_after_main_widgets.count }.by(-2)
          expect(all(".aside-after-main-widgets .widget").length).to eq existing_widget_count-2
        end
      end
    end
  end
end
