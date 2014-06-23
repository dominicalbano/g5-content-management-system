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
  if ENV["CI"]
    builder = page.driver.browser.action
    source = source.native
    target = target.native

    builder.click_and_hold source
    builder.move_to        target, 1, 11
    builder.move_to        target
    builder.release        target
    builder.perform
  else
    source.drag_to(target)
  end
end

def accept_confirm(page)
  return page.driver.browser.switch_to.alert.accept if ENV["CI"]
  page.driver.accept_js_confirms!
end

def dismiss_confirm(page)
  return page.driver.browser.switch_to.alert.dismiss if ENV["CI"]
  page.driver.dismiss_js_confirms!
end

def seed(file="example.yml")
  client = Fabricate(:client)
  location = Fabricate(:location)
  instructions = YAML.load_file("#{Rails.root}/spec/support/website_instructions/#{file}")
  website = WebsiteSeeder.new(location, instructions).seed
  website.assets << Fabricate(:asset)
  [client, location, website]
end
