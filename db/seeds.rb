2.times do
  user = User.create(email: Faker::Internet.email, password: Faker::Internet.password(8))
  3.times do
    user.tasks.create(title: Faker::Name.title, description: Faker::Lorem.paragraph)
  end
end