Fabricator(:user) do
  username { Faker::Name.name }
  password { "password" }
  email { Faker::Internet.email }
  admin false
end

Fabricator(:admin, from: :user) do
  admin true
end