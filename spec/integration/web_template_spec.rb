#
# IMPORTANT!
#
# The VCR gem records HTTP interactions to
# /spec/support/vcr_cassettes/web_template_requests
#
# If you want to record new interactions, delete these files.
#
# For more testing ideas, see https://github.com/jnicklas/capybara#the-dsl
# For other debugging ideas, see https://github.com/jnicklas/capybara#debugging
#
# Notes on `save_and_open_page`
#
# Due to the Rails asset pipeline, it does not work well, even with this fix
# http://stackoverflow.com/questions/13484808/save-and-open-page-not-working-with-capybara-2-0
#
# Notes on `page.save_screenshot('screenshot.png')`
#
# It works great! Use it. But only in development, do not push to Github.
#

require "spec_helper"

def set_setting(web_template, widget_name, setting_name, setting_value)
  widget = web_template.widgets.joins(:garden_widget).where("garden_widgets.name" => widget_name).first
  raise "Did not find '#{widget_name}' widget for web template '#{web_template.name}'" unless widget
  setting = widget.settings.where(name: setting_name).first
  raise "Did not find '#{setting_name}' setting for widget '#{widget_name}'" unless setting
  setting.update_attributes(value: setting_value)
end

describe "Integration '/web_template/:id'",
         auth_request: true, integration: true, js: true, vcr: VCR_OPTIONS do
  describe "Renders preview of compiled web template" do
    describe "website_instructions" do
      before do
        VCR.use_cassette("Gardens") do
          GardenWebLayoutUpdater.new.update_all
          GardenWebThemeUpdater.new.update_all
          GardenWidgetUpdater.new.update_all
        end

        @client = Fabricate(:client)
        @location = Fabricate(:location)
        @website = Seeder::WebsiteSeeder.new(@location).seed
        @web_page_template = @website.web_page_templates.first
      end

      describe "When settings are not set" do
        before do
          url = '/' + [@web_page_template.owner.urn, @web_page_template.url].join('/')
          visit url
        end

        it "has web template title in title tag" do
          puts page.html
          expect(page).to have_title @web_page_template.render_title
        end

        it "has a rel='canonical' link" do
          expect(page).to have_selector("link[rel=canonical][href='#{@web_page_template.page_url}']", visible: false)
        end

        it "displays name in navigation widget in nav section" do
          pending "Capybara finds the selector locally but not on CI."
          within "#drop-target-nav .navigation.widget" do
            expect(page).to have_content @web_page_template.name.upcase
          end
        end
      end

      describe "Liquid parsing in settings" do
        it "correctly parses and displays page name in title" do
          @web_page_template.update_attributes!(title: "{{page_name}}")
          url = '/' + [@web_page_template.owner.urn, @web_page_template.url].join('/')
          visit url
          expect(page).to have_title "#{@web_page_template.name}"
        end

      # it "correctly parses and displays location address in title" do
      #   @web_page_template.update_attributes!(title: "{{location_city}} {{location_neighborhood}} {{location_state}}")
      #   visit '/' + [@web_page_template.owner.urn, @web_page_template.url].join('/')
      #   expect(page).to have_title "#{@location.city} #{@location.neighborhood} #{@location.state}"
      # end

        it "correctly parses and displays location info in title" do
          @web_page_template.update_attributes!(title: "{{location_floor_plans}} {{location_primary_amenity}} {{location_qualifier}} {{location_primary_landmark}}")
          visit '/' + [@web_page_template.owner.urn, @web_page_template.url].join('/')
          expect(page).to have_title "#{@location.floor_plans} #{@location.primary_amenity} #{@location.qualifier} #{@location.primary_landmark}"
        end
      end

    end
  end
end
