Fabricator(:user) do
  username { Faker::Internet.user_name }
  uid { Faker::Lorem.characters(10) }
  verified true
end
