Fabricator :setting do
  name { Faker::Name.name }
  categories ["Instance"]
end

Fabricator :setting_with_owner, from: :setting do
  owner(fabricator: :widget)
end

Fabricator :column_one_widget_name, from: :setting do
  name {"column_one_widget_name"}
end

Fabricator :column_one_widget_id, from: :setting do
  name {"column_one_widget_id"}
end

