namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    puts "Populating users..."
    make_users
    puts "Populating microposts..."
    make_microposts
    puts "Populating relationships..."
    make_relationships
    puts "Populating recipes..."
    make_recipes
  end
end

def make_users  
  admin = User.create!(username: "username",
                       email: "em@il.com",
                       password: "password",
                       password_confirmation: "password",
                       admin: true)
  99.times do |n|
    username  = "user_#{n+1}"
    email = "user_#{n+1}@example.com"
    password  = "password"
    User.create!(username: username,
                 email: email,
                 password: password,
                 password_confirmation: password)
  end
end

def make_microposts
  users = User.all(limit: 6)
  50.times do
    content = Faker::Lorem.sentence(5)
    users.each { |user| user.microposts.create!(content: content) }
  end
end

def make_relationships
  users = User.all
  user = users.first
  followed_users = users[2..50]
  followers = users[3..40]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each { |follower| follower.follow!(user) }
end

def make_recipes
  users = User.all(limit:10)
  10.times do
    name = Faker::Lorem.sentence(3)
    description = Faker::Company.bs
    users.each { |user| user.recipes.create!(name: name, description: description) }
  end
end