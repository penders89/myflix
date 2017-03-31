Category.create(name: "comedies")
Category.create(name: "drama")
Category.create(name: "romance")

40.times do
  Video.create(category_id: (1..3).to_a.sample, 
    title: Faker::Lorem.words(4).join(' '), 
    small_cover: "https://dummyimage.com/166x236/#{"%06x" % (rand * 0xffffff)}/#{"%06x" % (rand * 0xffffff)}.jpg",
    large_cover: "https://dummyimage.com/665x375/000/fff.jpg", description: Faker::Lorem.paragraph)
end

100.times do 
  User.create(username: Faker::Name.name, password: "password", email: Faker::Internet.email)
end

User.first(20).each do |user| 
  Video.last(20).each do |video|
    if rand < 0.5 
      Review.create(content: Faker::Lorem.paragraph(2), rating: (1..5).to_a.sample, user: user, video: video)
    end
  end
end


