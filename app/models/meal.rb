# == Schema Information
#
# Table name: meals
#
#  id       :integer          not null, primary key
#  eaten_at :datetime
#  user_id  :integer
#

class Meal < ActiveRecord::Base
	
	belongs_to :user

	has_many :courses, through: :selected_recipes, source: :recipe
	has_many :selected_recipes

	validates :user_id, presence: true
	validates :eaten_at, presence: true

	def select!(recipe)
		self.selected_recipes.create!(recipe_id: recipe.id)
	end

	def unselect!(recipe)
		self.selected_recipes.find_by(recipe_id: recipe.id).destroy!
	end
end
