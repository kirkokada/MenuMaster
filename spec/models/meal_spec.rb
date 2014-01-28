# == Schema Information
#
# Table name: meals
#
#  id       :integer          not null, primary key
#  eaten_at :datetime
#  user_id  :integer
#

require 'spec_helper'

describe Meal do
	let(:user) { FactoryGirl.create :user }
	let(:meal) { user.meals.create(eaten_at: DateTime.now) }
	subject { meal }

	it { should respond_to :eaten_at }
	it { should respond_to :courses }
	it { should respond_to :selected_recipes }
	it { should respond_to :select! }
	it { should respond_to :unselect! }
	it { should respond_to :user_id }
	it { should respond_to :user }

	describe "when user_id isn't present" do
		before { meal.user_id = nil }
		it { should_not be_valid }
	end

	describe "selecting recipes" do
		let(:recipe) { FactoryGirl.create(:recipe, user: user) }

		before do 
			meal.save
			meal.select!(recipe)
		end

		its(:courses) { should include recipe }

		describe "then unselecting recipes" do
			before { meal.unselect!(recipe) }

			its(:courses) { should_not include recipe }
		end
	end

	describe "when eaten_at isn't present" do
		before { meal.eaten_at = nil }
		it { should_not be_valid }
	end
end
