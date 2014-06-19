LOCATION_SELECTOR = ".location:first-of-type"
WEB_HOME_SELECTOR = ".web-home-template:first-of-type"
WEB_PAGE_SELECTOR = ".web-page-template:first-of-type"
TOP_NAV          = ".page > .l-container > .page-title"

def scroll_to(page, selector)
  page.execute_script <<-EOS
(function($) {
  return $("html, body").animate({
    scrollTop: $('#{selector}').offset().top + "px"
  }, "fast");
})(jQuery);
  EOS
end

def drag_and_drop(source, target)
  return source.drag_to(target) if ENV["HEADLESS"]

  builder = page.driver.browser.action
  source = source.native
  target = target.native

  builder.click_and_hold source
  builder.move_to        target, 1, 11
  builder.move_to        target
  builder.release        target
  builder.perform
end

def accept_confirm(page)
  return page.driver.accept_js_confirms! if ENV["HEADLESS"]
  page.driver.browser.switch_to.alert.accept
end

def dismiss_confirm(page)
  return page.driver.dismiss_js_confirms! if ENV["HEADLESS"]
  page.driver.browser.switch_to.alert.dismiss
end

def seed(file="example.yml")
  client = Fabricate(:client)
  location = Fabricate(:location)
  instructions = YAML.load_file("#{Rails.root}/spec/support/website_instructions/#{file}")
  website = WebsiteSeeder.new(location, instructions).seed
  website.assets << Fabricate(:asset)
  [client, location, website]
end
