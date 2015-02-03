LOCATION_SELECTOR = ".location:first-of-type"
WEB_HOME_SELECTOR = ".web-home-template"
WEB_PAGE_SELECTOR = ".web-page-template"
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

def drag_and_drop(element, target)
  builder = page.driver.browser.action
  element = element.native
  target = target.native

  builder.click_and_hold(element)
  builder.move_to(target)
  builder.release
  builder.perform
end

def drag_and_drop_below(source, target)
  builder = page.driver.browser.action
  source = source.native
  target = target.native

  builder.click_and_hold source
  builder.move_to        target, (target.size.width)/2+1, (target.size.height)/2+1
  builder.release
  builder.perform
end

def drag_and_drop_add(element, target)
  builder = page.driver.browser.action
  element = element.native
  target = target.native

  builder.click_and_hold(element)
  builder.move_to(target, 5, 5)
  builder.release
  builder.perform
end

def accept_confirm(page)
  page.driver.browser.switch_to.alert.accept
end

def dismiss_confirm(page)
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

def open_gardens
  # add a long delay to make sure ember is done doing all it's black magic
  # otherwise we get intermittent failures when looking around in a garden
  sleep 3
  all(".btn--toggle-show").each do |toggle_button|
    toggle_button.click
  end
end
