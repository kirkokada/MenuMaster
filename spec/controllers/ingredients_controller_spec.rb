require 'spec_helper'

describe IngredientsController do
	let(:user) { FactoryGirl.create :user }
	let(:other_user) { FactoryGirl.create :user}
	let(:recipe) { FactoryGirl.create :recipe, user: user }
	let(:food) { FactoryGirl.create :food }

	before { sign_in user, no_capybara: true }

	describe "creating an ingredient with AJAX" do

		it "should increment the Ingredient count" do
			expect do
				xhr :post, :create, recipe_id: recipe.id, ingredient: { food_id: food.id, amount: 0 }
			end.to change(Ingredient, :count).by(1)
		end

		it "should respond with success" do
			xhr :post, :create, recipe_id: recipe.id, ingredient: { food_id: food.id, amount: 0 }
			expect(response).to be_success
		end
	end

	describe "destroying an ingredient with AJAX" do
		before { recipe.ingredients.create(food_id: food.id, amount: 0 ) }
		let!(:ingredient) { recipe.ingredients.find_by_food_id(food.id) }

		it "should decrement the Ingredient count" do
			expect do
				xhr :delete, :destroy, recipe_id: recipe.id, id: ingredient.id 
			end.to change(Ingredient, :count).by(-1)
		end

		it "should respond with success" do
			xhr :delete, :destroy, recipe_id: recipe.id, id: ingredient.id
			expect(response).to be_success
		end
	end
end
