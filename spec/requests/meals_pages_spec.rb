require 'spec_helper'

describe "MealsPages" do
	subject { page }
	let(:user) { FactoryGirl.create :user }
	let(:recipe) { FactoryGirl.create :recipe, user: user }

  describe "meal creation" do
  	before do
  		sign_in user
  		visit new_user_meal_path(user)
  	end

  	describe "page" do
  		it { should have_title "Record Meal" }
  	end

  	describe "with invalid information" do
  		before do
  		  click_button "Save"
  		end

  		it { should have_selector ".alert.alert-error" }
  	end
  end
end
