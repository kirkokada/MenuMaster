require 'spec_helper'

describe "IngredientPages" do
  let!(:user) { FactoryGirl.create :user }
  let!(:food) { FactoryGirl.create :food }
  let!(:recipe) { FactoryGirl.create :recipe, user: user }
  
  subject { page }

  describe "Add ingredient" do
		before do 
			sign_in user
			visit new_recipe_ingredient_path(recipe)
		end

  	describe "page" do

  		it { should have_title "Add ingredient" }
  		it { should have_content food.name }
  		it { should have_selector "div#food_#{food.id}" }
  		it { should have_button "Add" }
      it { should have_link "Return", href: recipe_path(recipe) }
  	end

  	describe "add ingredient button" do
      let(:amount) { "20" }
      before do
        within "div#food_#{food.id}" do
          fill_in "Amount", with: amount
        end 
      end
  		
  		it "should increment the ingredient count" do
  			expect { click_button "Add" }.to change(Ingredient, :count).by(1)
  		end

  		describe "after clicking the button", js: true do
  			before { click_button "Add" }
  			it { should have_content amount }
        it { should_not have_button "Add" }
  		end
  	end
  end
end
