Fabricator(:phase) do
  name { Faker::Name.name }
  start { Faker::Time.forward(10) }
end
