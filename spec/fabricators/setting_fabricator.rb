Fabricator :setting do
  name { Faker::Name.name } 
  categories ["Instance"]
  component(fabricator: :widget)
  widget_attributes(count: 1)
end
