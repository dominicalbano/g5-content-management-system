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
  settings do
    [
      {:name=>"row_layout", :editable=>"true", :default_value=>"", :categories=>["Instance"]},
      {:name=>"column_one_widget_name", :editable=>"true", :default_value=>"", :categories=>["Instance"]},
      {:name=>"column_one_widget_id", :editable=>"true", :default_value=>"", :categories=>["Instance"]},
      {:name=>"column_two_widget_name", :editable=>"true", :default_value=>"", :categories=>["Instance"]},
      {:name=>"column_two_widget_id", :editable=>"true", :default_value=>"", :categories=>["Instance"]},
      {:name=>"column_three_widget_name", :editable=>"true", :default_value=>"", :categories=>["Instance"]},
      {:name=>"column_three_widget_id", :editable=>"true", :default_value=>"", :categories=>["Instance"]},
      {:name=>"column_four_widget_name", :editable=>"true", :default_value=>"", :categories=>["Instance"]},
      {:name=>"column_four_widget_id", :editable=>"true", :default_value=>"", :categories=>["Instance"]}
    ]
  end
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
  settings do
    [
      {:name=>"row_count", :editable=>"true", :default_value=>"", :categories=>["Instance"]},
      {:name=>"row_one_widget_name", :editable=>"true", :default_value=>"", :categories=>["Instance"]},
      {:name=>"row_one_widget_id", :editable=>"true", :default_value=>"", :categories=>["Instance"]},
      {:name=>"row_two_widget_name", :editable=>"true", :default_value=>"", :categories=>["Instance"]},
      {:name=>"row_two_widget_id", :editable=>"true", :default_value=>"", :categories=>["Instance"]},
      {:name=>"row_three_widget_name", :editable=>"true", :default_value=>"", :categories=>["Instance"]},
      {:name=>"row_three_widget_id", :editable=>"true", :default_value=>"", :categories=>["Instance"]},
      {:name=>"row_four_widget_name", :editable=>"true", :default_value=>"", :categories=>["Instance"]},
      {:name=>"row_four_widget_id", :editable=>"true", :default_value=>"", :categories=>["Instance"]},
      {:name=>"row_five_widget_name", :editable=>"true", :default_value=>"", :categories=>["Instance"]},
      {:name=>"row_five_widget_id", :editable=>"true", :default_value=>"", :categories=>["Instance"]},
      {:name=>"row_six_widget_name", :editable=>"true", :default_value=>"", :categories=>["Instance"]},
      {:name=>"row_six_widget_id", :editable=>"true", :default_value=>"", :categories=>["Instance"]}
    ]
  end
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
  settings do
    [
      {:name=>"text", :editable=>"true", :default_value=>"", :categories=>["Instance"]}
    ]
  end
end

Fabricator :meta_description_garden_widget, from: :garden_widget do
  url { Faker::Internet.url }
  name { "Meta Description" }
  widget_id { 28 }
  slug { |attrs| attrs[:name].to_s.parameterize }
  thumbnail { Faker::Internet.url }
  liquid { true }
  edit_html { "<div>edit</div>" }
  show_html { |attrs| "<div class=\"widget #{attrs[:slug]}\">show</div>" }
  widget_type { "G5 Internal" }
  settings do
    [
      {:name=>"meta_description", :editable=>"true", :default_value=>"", :categories=>["Instance"]}
    ]
  end
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

