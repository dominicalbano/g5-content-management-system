Fabricator :property_group do
  name { Faker::Name.name }
  categories ["Instance"]
  component(fabricator: :widget)
  properties(count: 1)
end
