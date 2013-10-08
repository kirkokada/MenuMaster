class Ingredient < ActiveRecord::Base
	belongs_to :recipe
	belongs_to :food

	before_create :set_nutritional_data

	before_update :set_nutritional_data

	validates :food_id, presence: true
	validates :amount, presence: true

	def name
		food.name
	end

	def proportion
		self.amount / 100.0 || 0
	end

	private

	def set_nutritional_data
		self.calories = food.calories * proportion
		self.carbs    = food.carbs    * proportion
		self.protein  = food.protein  * proportion
		self.fat      = food.fat      * proportion
	end
end
