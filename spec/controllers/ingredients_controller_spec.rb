require 'spec_helper'

describe IngredientsController do
	let(:user) { FactoryGirl.create :user }
	let(:recipe) { FactoryGirl.create :recipe, user: user }
	let(:food) { FactoryGirl.create :food }

	before { sign_in user, no_capybara: true }

	describe "creating an ingredient with AJAX" do

		def submit_ajax_post_request
			xhr :post, :create, recipe_id: recipe.id, ingredient: { food_id: food.id, amount: 0 }
		end

		it "should increment the Ingredient count" do
			expect { submit_ajax_post_request }.to change(Ingredient, :count).by(1)
		end

		it "should respond with success" do
			submit_ajax_post_request
			expect(response).to be_success
		end
	end

	describe "destroying an ingredient with AJAX" do
		before { recipe.ingredients.create(food_id: food.id, amount: 0 ) }

		let!(:ingredient) { recipe.ingredients.find_by_food_id(food.id) }

		def submit_ajax_delete_request
			xhr :delete, :destroy, recipe_id: recipe.id, id: ingredient.id 			
		end

		it "should decrement the Ingredient count" do
			expect { submit_ajax_delete_request }.to change(Ingredient, :count).by(-1)
		end

		it "should respond with success" do
			submit_ajax_delete_request
			expect(response).to be_success
		end
	end

	describe "editing an ingredient with AJAX" do
		let(:new_amount) { 20 }
		let(:ingredient) { FactoryGirl.create(:ingredient, recipe: recipe, food: food) }

		def submit_ajax_post_request
			xhr :post, :update, recipe_id: recipe.id, id: ingredient.id, ingredient: { amount: new_amount }			
		end

		it "should update the ingredient" do
			submit_ajax_post_request
			expect(ingredient.reload.amount).to eq new_amount
		end

		it "should respond with success" do
			submit_ajax_post_request
			expect(response).to be_success
		end
	end
end
