require 'spec_helper'

describe RecipesController do
	let(:user) { FactoryGirl.create(:user) }
	let(:food) { FactoryGirl.create(:food) }
	let(:recipe) { FactoryGirl.create(:recipe, user: user) }

	before { sign_in user, no_capybara: true }

	describe "updating a recipe with AJAX" do
		let(:new_name) { "New Name" }
		let(:new_description) { "New Description" }
		it "should update the recipe" do
			xhr :put, :update, id: recipe.id, recipe: { name: new_name, description: new_description }
			expect(response).to be_success
			expect(recipe.reload.name).to eq new_name
			expect(recipe.reload.description).to eq new_description
		end
	end
end
