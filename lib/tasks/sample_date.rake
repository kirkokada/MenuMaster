namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    User.create!(username: "username",
                 email: "em@il.com",
                 password: "password",
                 password_confirmation: "password")
    99.times do |n|
      username  = "user_#{n+1}"
      email = "user_#{n+1}@example.com"
      password  = "password"
      User.create!(username: username,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
    users = User.all(limit: 6)
    50.times do
      content = Faker::Lorem.sentence(5)
      users.each { |user| user.microposts.create!(content: content) }
    end
  end
end