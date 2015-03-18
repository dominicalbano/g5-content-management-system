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
      {:name=>"column_1_widget_name", :editable=>"true", :default_value=>"", :categories=>["Instance"]},
      {:name=>"column_1_widget_id", :editable=>"true", :default_value=>"", :categories=>["Instance"]},
      {:name=>"column_2_widget_name", :editable=>"true", :default_value=>"", :categories=>["Instance"]},
      {:name=>"column_2_widget_id", :editable=>"true", :default_value=>"", :categories=>["Instance"]},
      {:name=>"column_3_widget_name", :editable=>"true", :default_value=>"", :categories=>["Instance"]},
      {:name=>"column_3_widget_id", :editable=>"true", :default_value=>"", :categories=>["Instance"]},
      {:name=>"column_4_widget_name", :editable=>"true", :default_value=>"", :categories=>["Instance"]},
      {:name=>"column_4_widget_id", :editable=>"true", :default_value=>"", :categories=>["Instance"]}
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
      {:name=>"row_1_widget_name", :editable=>"true", :default_value=>"", :categories=>["Instance"]},
      {:name=>"row_1_widget_id", :editable=>"true", :default_value=>"", :categories=>["Instance"]},
      {:name=>"row_2_widget_name", :editable=>"true", :default_value=>"", :categories=>["Instance"]},
      {:name=>"row_2_widget_id", :editable=>"true", :default_value=>"", :categories=>["Instance"]},
      {:name=>"row_3_widget_name", :editable=>"true", :default_value=>"", :categories=>["Instance"]},
      {:name=>"row_3_widget_id", :editable=>"true", :default_value=>"", :categories=>["Instance"]},
      {:name=>"row_4_widget_name", :editable=>"true", :default_value=>"", :categories=>["Instance"]},
      {:name=>"row_4_widget_id", :editable=>"true", :default_value=>"", :categories=>["Instance"]},
      {:name=>"row_5_widget_name", :editable=>"true", :default_value=>"", :categories=>["Instance"]},
      {:name=>"row_5_widget_id", :editable=>"true", :default_value=>"", :categories=>["Instance"]},
      {:name=>"row_6_widget_name", :editable=>"true", :default_value=>"", :categories=>["Instance"]},
      {:name=>"row_6_widget_id", :editable=>"true", :default_value=>"", :categories=>["Instance"]}
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
  show_html { |attrs| "<div class=\"widget #{attrs[:slug]}\">{{ widget.text.value }}</div>" }
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
  settings do
    [
      {:name=>"tracking_code", :editable=>"true", :default_value=>"", :categories=>["Instance"]}, 
      {:name=>"go_squared_client_code", :editable=>"true", :default_value=>"", :categories=>["Instance"]}, 
      {:name=>"go_squared_code", :editable=>"true", :default_value=>"", :categories=>["Instance"]}
    ]
  end
end

