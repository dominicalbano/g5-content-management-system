Fabricator :location do
  uid { Faker::Internet.url }
  urn { "g5-cl-2398223-#{Faker::Name.name.parameterize}" }
  name { Faker::Name.name }
  state { Faker::Address.state_abbr }
  city { Faker::Address.city }
  domain { Faker::Internet.url }
  corporate { false }
  status { "Pending" }
end
