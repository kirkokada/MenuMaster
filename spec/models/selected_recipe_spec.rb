# == Schema Information
#
# Table name: selected_recipes
#
#  id         :integer          not null, primary key
#  meal_id    :integer
#  recipe_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe SelectedRecipe do
	let(:user) { FactoryGirl.create :user }
  let(:recipe) { FactoryGirl.create :recipe }
  let(:meal) { FactoryGirl.create :meal, user: user }
  let(:selected_recipe) { meal.selected_recipes.build(recipe_id: recipe.id)}

  subject { selected_recipe }

  describe "when meal_id isn't present" do
  	before { selected_recipe.meal_id = nil }

  	it { should_not be_valid }
  end
end
