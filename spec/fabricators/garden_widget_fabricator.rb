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

Fabricator :content_stripe_garden_widget, from: :garden_widget do
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
      {:name=>"text", :editable=>"true", :default_value=>"Lorem Ipsum", :categories=>["Instance"]}
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

Fabricator :calls_to_action_garden_widget, from: :garden_widget do
  url { Faker::Internet.url }
  name { "Calls To Action" }
  widget_id { 5 }
  slug { |attrs| attrs[:name].to_s.parameterize }
  thumbnail { Faker::Internet.url }
  liquid { true }
  edit_html { "<div>edit</div>" }
  show_html { |attrs| "<div class=\"widget #{attrs[:slug]}\">{{ widget.text.value }}</div>" }
  widget_type { "" }
  settings do
    [
      {:name=>"cta_text_1", :editable=>"true", :default_value=>"", :categories=>["Instance"]},
      {:name=>"page_slug_1", :editable=>"true", :default_value=>"", :categories=>["Instance"]},
      {:name=>"cta_text_2", :editable=>"true", :default_value=>"", :categories=>["Instance"]},
      {:name=>"page_slug_2", :editable=>"true", :default_value=>"", :categories=>["Instance"]},
      {:name=>"cta_text_3", :editable=>"true", :default_value=>"", :categories=>["Instance"]},
      {:name=>"page_slug_3", :editable=>"true", :default_value=>"", :categories=>["Instance"]},
      {:name=>"cta_text_4", :editable=>"true", :default_value=>"", :categories=>["Instance"]},
      {:name=>"page_slug_4", :editable=>"true", :default_value=>"", :categories=>["Instance"]}
    ]
  end
end

Fabricator :logo_garden_widget, from: :garden_widget do
  url { Faker::Internet.url }
  name { "Logo" }
  widget_id { 25 }
  slug { |attrs| attrs[:name].to_s.parameterize }
  thumbnail { Faker::Internet.url }
  liquid { true }
  edit_html { "<div>edit</div>" }
  show_html { |attrs| "<div class=\"widget #{attrs[:slug]}\">{{ widget.text.value }}</div>" }
  widget_type { "" }
  settings do
    [
      {:name=>"business_name", :editable=>"true", :default_value=>"", :categories=>["Instance"]},
      {:name=>"display_logo", :editable=>"true", :default_value=>"", :categories=>["Instance"]},
      {:name=>"single_domain_location", :editable=>"true", :default_value=>"", :categories=>["Instance"]},
      {:name=>"logo_url", :editable=>"true", :default_value=>"", :categories=>["Instance"]}
    ]
  end
end

Fabricator :photo_garden_widget, from: :garden_widget do
  url { Faker::Internet.url }
  name { "Photo" }
  widget_id { 34 }
  slug { |attrs| attrs[:name].to_s.parameterize }
  thumbnail { Faker::Internet.url }
  liquid { true }
  edit_html { "<div>edit</div>" }
  show_html { |attrs| "<div class=\"widget #{attrs[:slug]}\">{{ widget.text.value }}</div>" }
  widget_type { "" }
  settings do
    [
      {:name=>"photo_source_url", :editable=>"true", :default_value=>"", :categories=>["Instance"]},
      {:name=>"photo_link_url", :editable=>"true", :default_value=>"", :categories=>["Instance"]},
      {:name=>"photo_alt_tag", :editable=>"true", :default_value=>"", :categories=>["Instance"]},
      {:name=>"photo_caption", :editable=>"true", :default_value=>"", :categories=>["Instance"]},
      {:name=>"photo_alignment", :editable=>"true", :default_value=>"", :categories=>["Instance"]},
      {:name=>"photo_class", :editable=>"true", :default_value=>"", :categories=>["Instance"]}
    ]
  end
end

