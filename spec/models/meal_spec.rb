require 'spec_helper'

describe Meal do
	let(:user) { FactoryGirl.create :user }
	let(:recipe) { FactoryGirl.create :recipe, user: user }
	let(:meal) { user.meals.build(recipe_id: recipe.id, user_id: user.id, eaten_at: Date.today) }

	subject { meal }

	it { should respond_to :user_id }
	it { should respond_to :user }
	it { should respond_to :recipe_id }
	it { should respond_to :recipe }
	it { should respond_to :eaten_at }

	describe "when eaten_at is nil" do
		before { meal.eaten_at = nil }

		it { should_not be_valid }
	end

	describe "when eaten_at is in the future" do
		before { meal.eaten_at = Date.tomorrow }

		it { should_not be_valid}
	end

	describe "when user_id is nil" do
		before { meal.user_id = nil }

		it { should_not be_valid }
	end

	describe "when recipe_id is nil" do
		before { meal.recipe_id = nil }

		it { should_not be_valid }
	end
end
