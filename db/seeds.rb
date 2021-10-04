User.create!(name: "Example User 123",
              email: "example123@railstutorial.org",
              password: "foobar12345",
              password_confirmation: "foobar12345",
              admin: true,
              activated: true,
              activated_at: Time.zone.now)

5.times do |n|
  name = Faker::Name.name
  email = "example-#{rand(252...4350)}@test-vku.com"
  password = "password123"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end

users = User.order(:created_at).take(8)
5.times do
  content = Faker::Lorem.sentence(word_count: 5)
  users.each { |user| user.microposts.create!(content: content) }
end
