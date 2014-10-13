Fabricator :website do
  urn { "g5-clw-12345-#{Faker::Name.name}"}
  owner(fabricator: :location)
end
