# User.create!(name: "Example User 123",
#               email: "example123@railstutorial.org",
#               password: "foobar12345",
#               password_confirmation: "foobar12345",
#               admin: true)
5.times do |n|
  name = Faker::Name.name
  email = "example-#{rand(252...4350)}@test-vku.com"
  password = "password123"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password)
end
