LOCATION_SELECTOR = ".location:first-of-type"
WEB_HOME_SELECTOR = ".web-home-template:first-of-type"
WEB_PAGE_SELECTOR = ".web-page-template:first-of-type"
TOP_NAV          = ".page .l-container > .page-title"

def scroll_to(page, selector)
  page.execute_script <<-EOS
(function($) {
  return $("html, body").animate({
    scrollTop: $('#{selector}').offset().top + "px"
  }, "fast");
})(jQuery);
  EOS
end

def position(selector)
  coordinates = page.evaluate_script("$('#{selector}').position()")
  OpenStruct.new(coordinates)
end

def height(selector)
  page.evaluate_script("$('#{selector}').height()")
end

def width(selector)
  page.evaluate_script("$('#{selector}').width()")
end

def drag_and_drop(source_selector, target_selector)
  source = find(source_selector)
  target = find(target_selector)
  source.drag_to(target)
end

def drag_and_drop_below(source_selector, target_selector)
  source_pos = position(source_selector)
  target_pos = position(target_selector)

  offset_x = target_pos.left - source_pos.left + width(target_selector)/2 + 1
  offset_y = target_pos.top - source_pos.top + height(target_selector)/2 + 1

  find(source_selector).native.drag_by(offset_x, offset_y)
end

def drag_and_drop_add(source_selector, target_selector)
  source_pos = position(source_selector)
  target_pos = position(target_selector)

  offset_x = target_pos.left - source_pos.left + 5
  offset_y = target_pos.top - source_pos.top + 5

  find(source_selector).native.drag_by(offset_x, offset_y)
end

# Capybara 2.4.1 introduced a model API that is currently not supported by
# poltergeist, but probably will be in the near future (there was already
# an abortive attempt: https://github.com/teampoltergeist/poltergeist/pull/516)
# In the meantime, we'll mock out the capybara accept_confirm method to
# take advantage of poltergeist's default behavior of returning true from
# any call to window.confirm()
def accept_confirm(text_or_options=nil, options={}, &block)
  block.call
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
