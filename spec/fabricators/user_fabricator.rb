Fabricator(:user) do
  username { Faker::Name.name }
  password { "password" }
  email { Faker::Internet.email }
end