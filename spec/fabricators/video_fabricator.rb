Fabricator(:video) do
  title { Faker::Lorem.words(2).join(' ') }
  description { Faker::Lorem.paragraph(2) }
  small_cover { Faker::Lorem.word }
  large_cover { Faker::Lorem.word }
  category
end