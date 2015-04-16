Fabricator :setting do
  name { Faker::Name.name }
  categories ["Instance"]
  owner(fabricator: :widget)
end

Fabricator :column_1_widget_name, from: :setting do
  name {"column_1_widget_name"}
  categories ["Instance"]
end

Fabricator :column_1_widget_id, from: :setting do
  name {"column_1_widget_id"}
  categories ["Instance"]
end

