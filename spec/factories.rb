FactoryGirl.define do
	factory :user do
		sequence(:username) { |n| "user_#{n}"}
		sequence(:email) { |n| "user_#{n}@test.com" }
		password "password"
		password_confirmation "password"

		factory :admin do
			admin true
		end
	end

	factory :micropost do
		sequence(:content) { |n| "Micropost #{n}" }
		user
	end

	factory :ingredient do
		sequence(:name) { |n| "Ingredient #{n}"}
		sequence(:carbs) { |n| n * 2 }
		sequence(:protein) { |n| n * 3 }
		sequence(:fat) { |n| n * 4 }
		sequence(:calories) { |n| n * 5 }
	end
end