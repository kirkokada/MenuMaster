# == Schema Information
#
# Table name: ingredients
#
#  id         :integer          not null, primary key
#  food_id    :integer
#  recipe_id  :integer
#  amount     :integer
#  created_at :datetime
#  updated_at :datetime
#  calories   :float
#  protein    :float
#  carbs      :float
#  fat        :float
#  name       :string(255)
#

class Ingredient < ActiveRecord::Base
	include Search
	belongs_to :recipe
	belongs_to :food

	before_save :set_nutritional_values, :set_name
	after_save { self.recipe.set_nutritional_values }

	validates :food_id, presence: true
	validates :amount, presence: true

	def proportion
		self.amount / 100.0 || 0
	end

	private

	def set_name
		self.name = food.name
	end

	def set_nutritional_values
		self.calories = food.calories * proportion
		self.carbs    = food.carbs    * proportion
		self.protein  = food.protein  * proportion
		self.fat      = food.fat      * proportion
	end
end
