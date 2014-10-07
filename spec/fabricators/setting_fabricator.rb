Fabricator :setting do
  name { Faker::Name.name }
  categories ["Instance"]
  owner(fabricator: :widget)
end
