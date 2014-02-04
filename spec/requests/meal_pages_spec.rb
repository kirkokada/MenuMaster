require 'spec_helper'

describe "MealPages" do
	let(:user) { FactoryGirl.create :user }
	let!(:recipe) { FactoryGirl.create :recipe, user: user }

	subject { page }

	describe "meal creation" do
		before do
			sign_in user
		  visit new_user_meal_path(user)
		end

		describe "page" do
			it { should have_title full_title "Record Meal" }
			it { should have_selector 'h1', text: "Record Meal" }
		end

		describe "with invalid information" do
			before { click_button "Record" }

			it { should have_selector ".alert-error" }
		end

		describe "with valid information" do
			before { select recipe.name	}

			it "should create a meal record" do
				expect do
					click_button "Record"
				end.to change(Meal, :count).by 1
			end

			describe "after submission" do
				before { click_button "Record" }

				it { should have_selector ".alert-success" }
			end
		end
	end
end
