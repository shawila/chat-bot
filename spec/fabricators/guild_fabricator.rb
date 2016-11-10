Fabricator(:guild) do
  name { Faker::Name.name }
  uid { Faker::Lorem.characters(10) }
end
