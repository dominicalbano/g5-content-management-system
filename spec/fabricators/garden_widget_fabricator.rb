Fabricator :garden_widget do
  url { Faker::Internet.url }
  name { Faker::Name.name }
  widget_id { 1 }
  slug { |attrs| attrs[:name].to_s.parameterize }
  thumbnail { Faker::Internet.url }
  liquid { false }
  edit_html { "<div>edit</div>" }
  show_html { |attrs| "<div class=\"widget #{attrs[:slug]}\">show</div>" }
  widget_type { "" }
end

Fabricator :row_garden_widget, from: :garden_widget do
  url { Faker::Internet.url }
  name { "Content Stripe" }
  widget_id { 11 }
  slug { |attrs| attrs[:name].to_s.parameterize }
  liquid { false }
  thumbnail { Faker::Internet.url }
  edit_html { "<div>edit</div>" }
  show_html { |attrs| "<div class=\"widget #{attrs[:slug]}\">show</div>" }
  widget_type { "" }
end

Fabricator :column_garden_widget, from: :garden_widget do
  url { Faker::Internet.url }
  name { "Column" }
  widget_id { 6 }
  slug { |attrs| attrs[:name].to_s.parameterize }
  liquid { false }
  thumbnail { Faker::Internet.url }
  edit_html { "<div>edit</div>" }
  show_html { |attrs| "<div class=\"widget #{attrs[:slug]}\">show</div>" }
  widget_type { "" }
end


Fabricator :html_garden_widget, from: :garden_widget do
  url { Faker::Internet.url }
  name { "HTML" }
  widget_id { 21 }
  slug { |attrs| attrs[:name].to_s.parameterize }
  thumbnail { Faker::Internet.url }
  liquid { true }
  edit_html { "<div>edit</div>" }
  show_html { |attrs| "<div class=\"widget #{attrs[:slug]}\">show</div>" }
  widget_type { "" }
end

Fabricator :analytics_garden_widget, from: :garden_widget do
  url { Faker::Internet.url }
  name { "Analytics" }
  widget_id { 1 }
  slug { |attrs| attrs[:name].to_s.parameterize }
  thumbnail { Faker::Internet.url }
  liquid { false }
  edit_html { "<div>edit</div>" }
  show_html { |attrs| "<div class=\"widget #{attrs[:slug]}\">show</div>" }
  widget_type { "" }
end

