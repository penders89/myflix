Fabricator(:invitation) do
  friend_name { Faker::Name.name }
  friend_email { Faker::Internet.email }
  inviter
end